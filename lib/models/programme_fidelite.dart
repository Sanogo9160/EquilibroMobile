import 'utilisateur.dart';

class ProgrammeFidelite {
  final int id;
  final int points;
  final String niveau;
  final Utilisateur utilisateur;

  ProgrammeFidelite({
    required this.id,
    required this.points,
    required this.niveau,
    required this.utilisateur,
  });

  factory ProgrammeFidelite.fromJson(Map<String, dynamic> json) {
    return ProgrammeFidelite(
      id: json['id'],
      points: json['points'],
      niveau: json['niveau'],
      utilisateur: Utilisateur.fromJson(json['utilisateur']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'points': points,
      'niveau': niveau,
      'utilisateur': utilisateur.toJson(),
    };
  }
}
