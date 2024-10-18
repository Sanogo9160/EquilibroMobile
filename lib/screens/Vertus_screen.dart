import 'package:equilibromobile/services/article-service.dart';
import 'package:equilibromobile/widgets/video_manager_widget.dart';
import 'package:flutter/material.dart';
import '../models/article.dart';

class VertusScreen extends StatefulWidget {
  @override
  _VertusScreenState createState() => _VertusScreenState();
}

class _VertusScreenState extends State<VertusScreen> {
  final ArticleService _articleService = ArticleService();
  List<Article> _articles = [];

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    try {
      final articles = await _articleService.getArticles();
      setState(() {
        _articles = articles;
      });
    } catch (e) {
      print('Erreur lors de la récupération des articles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Articles avec Vidéos'),
      ),
      body: _articles.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _articles.length,
              itemBuilder: (context, index) {
                final article = _articles[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 4.0,
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          article.content,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(height: 8.0),
                        VideoManagerWidget(videoUrl: article.videoUrl),
                        SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
