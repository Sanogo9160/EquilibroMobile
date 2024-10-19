

import 'package:equilibromobile/models/Ingredient.dart';

class Recipe {
  final String label; // Nom de la recette
  final String image; // URL de l'image
  final String url;   // URL de la recette
  final List<Ingredient> ingredients; // Liste des ingrédients
  final int cookingTime; // Temps de cuisson en minutes

  Recipe({
    required this.label,
    required this.image,
    required this.url,
    required this.ingredients,
    required this.cookingTime,
  });

  // Factory pour créer un objet Recipe à partir d'un JSON
  factory Recipe.fromJson(Map<String, dynamic> json) {
    var ingredientList = json['ingredients'] as List;
    List<Ingredient> ingredients = ingredientList.map((i) => Ingredient.fromJson(i)).toList();

    return Recipe(
      label: json['label'],
      image: json['image'],
      url: json['url'],
      ingredients: ingredients,
      cookingTime: json['cookingTime'],
    );
  }

  // Méthode pour convertir un objet Recipe en JSON
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'image': image,
      'url': url,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'cookingTime': cookingTime,
    };
  }
}