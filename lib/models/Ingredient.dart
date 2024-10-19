class Ingredient {
  final String name; // Nom de l'ingrédient
  final String quantity; // Quantité de l'ingrédient

  Ingredient({required this.name, required this.quantity});

  // Factory pour créer un objet Ingredient à partir d'un JSON
  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'],
      quantity: json['quantity'],
    );
  }

  // Méthode pour convertir un objet Ingredient en JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
    };
  }
}