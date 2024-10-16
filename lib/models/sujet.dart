import 'message.dart';

class Sujet {
  final int id;
  final String titre;
  final DateTime dateCreation;
  final List<Message> messages;

  Sujet({
    required this.id,
    required this.titre,
    required this.dateCreation,
    required this.messages,
  });

  factory Sujet.fromJson(Map<String, dynamic> json) {
    return Sujet(
      id: json['id'],
      titre: json['titre'],
      dateCreation: DateTime.parse(json['dateCreation']),
      messages: List<Message>.from(json['messages'].map((m) => Message.fromJson(m))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'dateCreation': dateCreation.toIso8601String(),
      'messages': messages.map((m) => m.toJson()).toList(),
    };
  }
}
