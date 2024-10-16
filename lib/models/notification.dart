import 'utilisateur.dart';

class Notification {
  final int id;
  final String type;
  final String message;
  final DateTime heure;
  final Utilisateur utilisateur;

  Notification({
    required this.id,
    required this.type,
    required this.message,
    required this.heure,
    required this.utilisateur,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      type: json['type'],
      message: json['message'],
      heure: DateTime.parse(json['heure']),
      utilisateur: Utilisateur.fromJson(json['utilisateur']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'message': message,
      'heure': heure.toIso8601String(),
      'utilisateur': utilisateur.toJson(),
    };
  }
}
