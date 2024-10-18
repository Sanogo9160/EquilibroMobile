import 'package:equilibromobile/models/forum.dart';
import 'package:equilibromobile/screens/forum_detail_screen.dart';
import 'package:equilibromobile/services/ForumService.dart';
import 'package:flutter/material.dart';


class Communautescreen extends StatefulWidget {
  @override
  _CommunautescreenState createState() => _CommunautescreenState();
}

class _CommunautescreenState extends State<Communautescreen> {
  late Future<List<Forum>> _forumsFuture;

  @override
  void initState() {
    super.initState();
    _forumsFuture = ForumService().obtenirTousForums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Communauté'),
      ),
      body: FutureBuilder<List<Forum>>(
        future: _forumsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun forum disponible.'));
          }

          final forums = snapshot.data!;
          return ListView.builder(
            itemCount: forums.length,
            itemBuilder: (context, index) {
              final forum = forums[index];
              return Card(
                child: ListTile(
                  title: Text(forum.nom),
                  subtitle: Text(forum.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForumDetailScreen(forum: forum),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}