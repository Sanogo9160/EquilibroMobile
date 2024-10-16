import 'utilisateur.dart';

class ProgrammeExercice {
  final int id;
  final String nom;
  final String description;
  final String niveau;
  final Utilisateur utilisateur;

  ProgrammeExercice({
    required this.id,
    required this.nom,
    required this.description,
    required this.niveau,
    required this.utilisateur,
  });

  factory ProgrammeExercice.fromJson(Map<String, dynamic> json) {
    return ProgrammeExercice(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      niveau: json['niveau'],
      utilisateur: Utilisateur.fromJson(json['utilisateur']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'niveau': niveau,
      'utilisateur': utilisateur.toJson(),
    };
  }
}
