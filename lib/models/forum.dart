
class Forum {
  final int id;
  final String nom;
  final String description;

  Forum({
    required this.id,
    required this.nom,
    required this.description,
  });

  factory Forum.fromJson(Map<String, dynamic> json) {
    return Forum(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
    );
  }
}