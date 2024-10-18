import 'package:equilibromobile/models/commentaire.dart';
import 'package:equilibromobile/models/forum.dart';
import 'package:equilibromobile/services/ForumService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

class ForumDetailScreen extends StatefulWidget {
  final Forum forum;

  ForumDetailScreen({required this.forum});

  @override
  _ForumDetailScreenState createState() => _ForumDetailScreenState();
}

class _ForumDetailScreenState extends State<ForumDetailScreen> {
  late Future<List<Commentaire>> _commentairesFuture;
  final TextEditingController _commentaireController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _commentairesFuture = ForumService().obtenirCommentairesParForum(widget.forum.id);
  }

  @override
  void dispose() {
    _commentaireController.dispose();
    super.dispose();
  }

  void _ajouterCommentaire() async {
    final contenu = _commentaireController.text.trim();
    if (contenu.isNotEmpty) {
      try {
        final nouveauCommentaire = Commentaire(
          id: 0, // ID géré par le backend
          contenu: contenu,
          date: DateTime.now(),
          forum: widget.forum,
        );
        await ForumService().creerCommentaire(nouveauCommentaire);
        _commentaireController.clear();
        setState(() {
          _commentairesFuture = ForumService().obtenirCommentairesParForum(widget.forum.id);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout du commentaire : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.forum.nom),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Commentaire>>(
              future: _commentairesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur : ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucun commentaire disponible.'));
                }

                final commentaires = snapshot.data!;
                return ListView.builder(
                  itemCount: commentaires.length,
                  itemBuilder: (context, index) {
                    final commentaire = commentaires[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            commentaire.contenu,
                            style: TextStyle(fontSize: 16.0, color: Colors.black), // Couleur du texte
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'Posté le ${DateFormat('dd/MM/yyyy HH:mm').format(commentaire.date)}',
                            style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
                          ),
                        ],
                      ),
                    );
                  },
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
                    controller: _commentaireController,
                    style: TextStyle(color: Colors.black), // Couleur du texte dans le TextField
                    decoration: InputDecoration(
                      hintText: 'Ajouter un commentaire',
                      hintStyle: TextStyle(color: Colors.grey), // Couleur de l'indice
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: _ajouterCommentaire,
                  child: Text('Publier'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}