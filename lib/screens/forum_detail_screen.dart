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
  TextEditingController _commentController = TextEditingController();
  List<bool> _expandedComments = [];

  @override
  void initState() {
    super.initState();
    _commentController.addListener(_onCommentChanged);
    _loadForumDetails();
  }

  void _onCommentChanged() {
    setState(() {}); 
  }

  Future<void> _loadForumDetails() async {
    try {
      final forumService = ForumService();
      final forumDetails = await forumService.getForumDetails(widget.forumId);
      
      print('Forum Details: $forumDetails'); // Debugging output

      setState(() {
        _forum = forumDetails;
        _isLoading = false;
        _expandedComments = List<bool>.filled(
            (forumDetails['commentaires'] as List?)?.length ?? 0, false);
      });
    } catch (e) {
      print('Erreur lors de la récupération des détails du forum: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addComment() async {
    final forumService = ForumService();
    if (_commentController.text.isNotEmpty) {
      await forumService.addComment(widget.forumId, _commentController.text);
      await _loadForumDetails();
      _commentController.clear(); 
    }
  }

  @override
  void dispose() {
    _commentController.removeListener(_onCommentChanged);
    _commentController.dispose();
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
                  child: (_forum?['commentaires'] as List?)?.isEmpty ?? true
                      ? Center(child: Text("Aucun commentaire pour l'instant"))
                      : ListView.builder(
                          itemCount: (_forum?['commentaires'] as List?)?.length ?? 0,
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
                          controller: _commentController,
                          style: const TextStyle(color: Colors.black),
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


