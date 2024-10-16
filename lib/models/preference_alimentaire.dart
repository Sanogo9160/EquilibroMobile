class PreferenceAlimentaire {
  final int id;
  final String nom;
  final String description;

  PreferenceAlimentaire({
    required this.id,
    required this.nom,
    required this.description,
  });

  factory PreferenceAlimentaire.fromJson(Map<String, dynamic> json) {
    return PreferenceAlimentaire(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
    );
  }
}