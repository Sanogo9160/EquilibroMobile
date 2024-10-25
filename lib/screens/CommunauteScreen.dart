import 'package:flutter/material.dart';
import 'package:equilibromobile/services/ForumService.dart';
import 'forum_detail_screen.dart';

class CommunauteScreen extends StatefulWidget {
  @override
  _CommunauteScreenState createState() => _CommunauteScreenState();
}

class _CommunauteScreenState extends State<CommunauteScreen> {
  List<dynamic> _forums = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadForums();
  }

  Future<void> _loadForums() async {
    try {
      final forumService = ForumService();
      final fetchedForums = await forumService.getForums();
      setState(() {
        _forums = fetchedForums;
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur lors de la récupération des forums: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forums', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.teal, // AppBar en couleur teal
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemCount: _forums.length,
                itemBuilder: (context, index) {
                  final forum = _forums[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        forum['nom'],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        forum['description'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForumDetailScreen(forumId: forum['id']),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
