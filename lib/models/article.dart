import 'package:flutter/foundation.dart';

class Article {
  final int id;
  final String title;
  final String content;
  final String videoUrl;

  Article({required this.id, required this.title, required this.content, required this.videoUrl});

  factory Article.fromJson(Map<String, dynamic> json) {
  return Article(
  id: json['id'],
  title: json['title'],
  content: json['content'],
  videoUrl: json['videoUrl'],
  );
  }

}
