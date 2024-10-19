import 'package:equilibromobile/models/Recipe.dart';
import 'package:flutter/material.dart';


class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.label),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(recipe.image),
            SizedBox(height: 16.0),
            Text('Ingredients:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...recipe.ingredients.map((ingredient) => Text('${ingredient.quantity} ${ingredient.name}')).toList(),
            SizedBox(height: 16.0),
            Text('Cooking Time: ${recipe.cookingTime} minutes'),
            SizedBox(height: 16.0),
            Text('Recipe URL:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(recipe.url),
          ],
        ),
      ),
    );
  }
}