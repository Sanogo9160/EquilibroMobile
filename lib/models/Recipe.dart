class Recipe {
  final String label;
  final String image;
  final String url;
  final int cookingTime;
  final List<String> ingredients;
  final Map<String, NutritionalInfo>? nutritionalInfo;
  final String category;

  Recipe({
    required this.label,
    required this.image,
    required this.url,
    required this.cookingTime,
    required this.ingredients,
    required this.category,
    this.nutritionalInfo,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      label: json['label'] ?? 'Recette sans nom',
      image: json['image'] ?? '',
      url: json['url'] ?? '',
      cookingTime: json['cookingTime'] ?? 0,
      ingredients: List<String>.from(json['ingredients'] ?? []),
      category: json['category'] ?? 'carnivore',
      nutritionalInfo: (json['nutritionalInfo'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, NutritionalInfo.fromJson(value))),
    );
  }
}

class NutritionalInfo {
  final double quantity;
  final String unit;

  NutritionalInfo({required this.quantity, required this.unit});

  factory NutritionalInfo.fromJson(Map<String, dynamic> json) {
    return NutritionalInfo(
      quantity: (json['quantity'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
    );
  }
}
