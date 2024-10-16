class ProfessionnelSante {
  final int id;
  final String nom;
  final String specialite;
  final String contact;

  ProfessionnelSante({
    required this.id,
    required this.nom,
    required this.specialite,
    required this.contact,
  });

  factory ProfessionnelSante.fromJson(Map<String, dynamic> json) {
    return ProfessionnelSante(
      id: json['id'],
      nom: json['nom'],
      specialite: json['specialite'],
      contact: json['contact'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'specialite': specialite,
      'contact': contact,
    };
  }
}
