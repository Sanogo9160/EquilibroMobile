class Forum {
  final int id;
  final String nom;
  final String description;
  final String auteur;
  final DateTime dateCreation;

  Forum({
    required this.id,
    required this.nom,
    required this.description,
    required this.auteur,
    required this.dateCreation,
  });

  factory Forum.fromJson(Map<String, dynamic> json) {
    return Forum(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      auteur: json['auteur']['nom'],
      dateCreation: DateTime.parse(json['dateCreation']),
    );
  }
}
