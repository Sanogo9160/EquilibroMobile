class Maladie {
  final int id;
  final String nom;
  final String? description;

  Maladie({
    required this.id,
    required this.nom,
    this.description,
  });

  factory Maladie.fromJson(Map<String, dynamic> json) {
    return Maladie(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
    };
  }
}