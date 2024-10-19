import 'package:flutter/foundation.dart';

class Article {
  final int id;
  final String titre;
  final String contenu;
  final String videoUrl;

  Article({
    required this.id,
    required this.titre,
    required this.contenu,
    required this.videoUrl,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      titre: json['titre'],
      contenu: json['contenu'],
      videoUrl: json['videoUrl'],
    );
  }
}
