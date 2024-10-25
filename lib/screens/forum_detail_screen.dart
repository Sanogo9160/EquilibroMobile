import 'package:flutter/material.dart';
import 'package:equilibromobile/services/ForumService.dart';

class ForumDetailScreen extends StatefulWidget {
  final int forumId;

  ForumDetailScreen({required this.forumId});

  @override
  _ForumDetailScreenState createState() => _ForumDetailScreenState();
}

class _ForumDetailScreenState extends State<ForumDetailScreen> {
  Map<String, dynamic>? _forum;
  bool _isLoading = true;
  TextEditingController _commentController = TextEditingController(); // Utilisation d'un contrôleur
  List<bool> _expandedComments = [];

  @override
  void initState() {
    super.initState();
    _loadForumDetails();
  }

  Future<void> _loadForumDetails() async {
    try {
      final forumService = ForumService();
      final forumDetails = await forumService.getForumDetails(widget.forumId);
      setState(() {
        _forum = forumDetails;
        _isLoading = false;
        _expandedComments = List<bool>.filled(forumDetails['commentaires'].length, false);
      });
    } catch (e) {
      print('Erreur lors de la récupération des détails du forum: $e');
    }
  }

  Future<void> _addComment() async {
    final forumService = ForumService();
    await forumService.addComment(widget.forumId, _commentController.text);
    await _loadForumDetails();
    _commentController.clear(); // Vider le champ de texte
  }

  Future<void> _deleteComment(int commentId) async {
    final forumService = ForumService();
    await forumService.deleteComment(commentId);
    await _loadForumDetails();
  }

  Future<void> _editComment(int commentId, String newContent) async {
    final forumService = ForumService();
    await forumService.editComment(commentId, newContent);
    await _loadForumDetails();
  }

  void _showEditDialog(int commentId, String currentContent) {
    TextEditingController controller = TextEditingController(text: currentContent);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier le commentaire'),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.black), // Texte noir
            decoration: const InputDecoration(hintText: "Nouveau contenu"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _editComment(commentId, controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Modifier'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(int commentId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: const Text('Êtes-vous sûr de vouloir supprimer ce commentaire ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Annuler
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                _deleteComment(commentId);
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _commentController.dispose(); // Nettoyer le contrôleur
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du forum'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _forum?['nom'] ?? '',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _forum?['description'] ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _forum?['commentaires']?.length ?? 0,
                    itemBuilder: (context, index) {
                      final comment = _forum?['commentaires'][index];
                      final author = comment['auteur'];
                      final avatarInitial = author['email'][0].toUpperCase();

                      String contenu = comment['contenu'];
                      int commentId = comment['id'];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _expandedComments[index] = !_expandedComments[index];
                            });
                          },
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.teal,
                                child: Text(
                                  avatarInitial,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                _expandedComments[index]
                                    ? contenu
                                    : (contenu.length > 100 ? '${contenu.substring(0, 100)}...' : contenu),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Par ${author['email']}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  if (!_expandedComments[index] && contenu.length > 100)
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _expandedComments[index] = true;
                                        });
                                      },
                                      child: const Text('Voir plus', style: TextStyle(color: Colors.teal)),
                                    ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.teal),
                                        onPressed: () {
                                          _showEditDialog(commentId, contenu);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          _showDeleteConfirmationDialog(commentId);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController, // Assignation du contrôleur
                          onChanged: (value) {
                            setState(() {
                              // On peut garder cette partie, mais elle n'est plus nécessaire si vous utilisez le contrôleur
                            });
                          },
                          style: const TextStyle(color: Colors.black), // Texte noir
                          decoration: InputDecoration(
                            hintText: 'Ajouter un commentaire',
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _commentController.text.isEmpty ? null : _addComment,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.all(14),
                        ),
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}