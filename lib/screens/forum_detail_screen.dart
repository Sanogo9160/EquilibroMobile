
import 'dart:convert';
import 'package:equilibromobile/config.dart';
import 'package:equilibromobile/services/ForumService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForumDetailScreen extends StatefulWidget {
  final int forumId;

  ForumDetailScreen({required this.forumId});

  @override
  _ForumDetailScreenState createState() => _ForumDetailScreenState();
}

class _ForumDetailScreenState extends State<ForumDetailScreen> {
  Map<String, dynamic>? _forum;
  bool _isLoading = true;
  String _newComment = '';

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
      });
    } catch (e) {
      print('Erreur lors de la récupération des détails du forum: $e');
    }
  }

  Future<void> _addComment() async {
    final forumService = ForumService();
    await forumService.addComment(widget.forumId, _newComment);
    await _loadForumDetails();
    setState(() {
      _newComment = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détails du forum')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_forum?['nom'] ?? '', style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 10),
                      Text(_forum?['description'] ?? ''),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _forum?['commentaires']?.length ?? 0,
                    itemBuilder: (context, index) {
                      final comment = _forum?['commentaires'][index];
                      return ListTile(
                        title: Text(comment['contenu']),
                        subtitle: Text('Par ${comment['auteur']['email']}'),
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
                          onChanged: (value) {
                            setState(() {
                              _newComment = value;
                            });
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(hintText: 'Ajouter un commentaire'),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _newComment.isEmpty ? null : _addComment,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}