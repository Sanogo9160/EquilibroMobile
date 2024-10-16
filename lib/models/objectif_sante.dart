class ObjectifSante {
  final int id;
  final String nom;
  final String description;

  ObjectifSante({
    required this.id,
    required this.nom,
    required this.description,
  });

  factory ObjectifSante.fromJson(Map<String, dynamic> json) {
    return ObjectifSante(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
    );
  }
}

