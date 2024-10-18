import 'forum.dart';

class Commentaire {
  final int id;
  final String contenu;
  final DateTime date;
  final Forum forum;

  Commentaire({
    required this.id,
    required this.contenu,
    required this.date,
    required this.forum,
  });

  factory Commentaire.fromJson(Map<String, dynamic> json) {
    return Commentaire(
      id: json['id'],
      contenu: json['contenu'],
      date: DateTime.parse(json['date']),
      forum: Forum.fromJson(json['forum']),
    );
  }
}