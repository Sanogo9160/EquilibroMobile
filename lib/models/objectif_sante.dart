class ObjectifSante {
  final int id;
  final String nom;
  final String? description;

  ObjectifSante({
    required this.id,
    required this.nom,
    this.description,
  });

  factory ObjectifSante.fromJson(Map<String, dynamic> json) {
    return ObjectifSante(
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