class Ingredient {
  final int id;
  final String nom;
  final bool risque;
  final String typeRisque;

  Ingredient({
    required this.id,
    required this.nom,
    required this.risque,
    required this.typeRisque,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      nom: json['nom'],
      risque: json['risque'],
      typeRisque: json['typeRisque'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'risque': risque,
      'typeRisque': typeRisque,
    };
  }
}
