
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
      name: json['name'] ?? 'Inconnu', // Valeur par défaut si null
      quantity: json['quantity'] ?? '0', // Valeur par défaut si null
    );
  }
}
