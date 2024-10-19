import 'dart:convert';
import 'package:equilibromobile/config.dart';
import 'package:equilibromobile/screens/forum_detail_screen.dart';
import 'package:equilibromobile/services/ForumService.dart';

import 'package:flutter/material.dart';

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
      appBar: AppBar(title: Text('Forums')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _forums.length,
              itemBuilder: (context, index) {
                final forum = _forums[index];
                return ListTile(
                  title: Text(forum['nom']),
                  subtitle: Text(forum['description']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForumDetailScreen(forumId: forum['id']),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
