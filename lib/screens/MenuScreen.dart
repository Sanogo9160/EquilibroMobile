/*
import 'package:equilibromobile/models/recipe.dart';
import 'package:equilibromobile/screens/RecipeDetailScreen.dart';
import 'package:flutter/material.dart';

import '../services/recette_service.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<Map<String, List<Recipe>>> futureRecipes;
  final recetteService = RecetteService();

  @override
  void initState() {
    super.initState();
    futureRecipes = recetteService.fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recettes"),
      ),
      body: FutureBuilder<Map<String, List<Recipe>>>(
        future: futureRecipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune recette trouvée.'));
          }

          final recipesByCategory = snapshot.data!;
          return ListView(
            children: recipesByCategory.entries.map((entry) {
              String category = entry.key;
              List<Recipe> recipes = entry.value;

              return ExpansionTile(
                title: Text(category.toUpperCase()),
                children: recipes.map((recipe) {
                  return RecipeTile(recipe: recipe);
                }).toList(),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class RecipeTile extends StatelessWidget {
  final Recipe recipe;

  const RecipeTile({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(recipe.label),
      subtitle: Text('Temps de cuisson: ${recipe.cookingTime} min'),
      leading: recipe.image.isNotEmpty
          ? Image.network(recipe.image, errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.broken_image);
            })
          : Icon(Icons.no_photography),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(recipe: recipe),
          ),
        );
      },
    );
  }
}

*/
