import 'package:equilibromobile/models/Ingredient.dart';

class Recipe {
  final String label;
  final String image;
  final String url;
  final List<Ingredient> ingredients;
  final int cookingTime;

  Recipe({
    required this.label,
    required this.image,
    required this.url,
    required this.ingredients,
    required this.cookingTime,
  });

  // Factory pour créer un objet Recipe à partir de JSON
  factory Recipe.fromJson(Map<String, dynamic> json) {
    var ingredientList = json['ingredients'] as List?; // Notez le '?' pour rendre cela nullable
    List<Ingredient> ingredients = ingredientList != null
        ? ingredientList.map((i) => Ingredient.fromJson(i)).toList()
        : []; // Utiliser une liste vide si null

    return Recipe(
      label: json['label'] ?? 'Inconnu', // Valeur par défaut si null
      image: json['image'] ?? '', // Valeur par défaut si null
      url: json['url'] ?? '', // Valeur par défaut si null
      ingredients: ingredients,
      cookingTime: json['cookingTime'] ?? 0, // Valeur par défaut si null
    );
  }
}
