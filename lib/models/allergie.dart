
class Allergie {
  final int id;
  final String nom;
  final String description;

  Allergie({
    required this.id,
    required this.nom,
    required this.description,
  });

  factory Allergie.fromJson(Map<String, dynamic> json) {
    return Allergie(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
    );
  }
}