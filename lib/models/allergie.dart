class Allergie {
  final int id;
  final String nom;
  final String? description;

  Allergie({
    required this.id,
    required this.nom,
    this.description,
  });

  factory Allergie.fromJson(Map<String, dynamic> json) {
    return Allergie(
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