
import 'package:equilibromobile/models/sujet.dart';

class Forum {
  final int id;
  final String nom;
  final String description;
  final List<Sujet> sujets;

  Forum({
    required this.id,
    required this.nom,
    required this.description,
    required this.sujets,
  });

  factory Forum.fromJson(Map<String, dynamic> json) {
    return Forum(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      sujets: (json['sujets'] as List<dynamic>)
          .map((item) => Sujet.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'sujets': sujets.map((sujet) => sujet.toJson()).toList(),
    };
  }
}
