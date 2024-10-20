
class Ingredient {
  final String name;
  final String quantity;

  Ingredient({
    required this.name,
    required this.quantity,
  });

  // Factory pour créer un objet Ingredient à partir de JSON
  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] ?? 'Ingrédient inconnu', // Valeur par défaut si le nom est absent
      quantity: json['quantity'] ?? 'Quantité inconnue', // Valeur par défaut
    );
  }
}
