import 'package:equilibromobile/models/Recipe.dart';
import 'package:equilibromobile/screens/RecipeDetailScreen.dart';
import 'package:equilibromobile/services/recette_service.dart';
import 'package:flutter/material.dart';


class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<List<Recipe>> futureRecipes;

  @override
  void initState() {
    super.initState();
    futureRecipes = RecetteService().fetchRecipes(); // Appel au service pour récupérer toutes les recettes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recettes"),
      ),
      body: Center(
        child: FutureBuilder<List<Recipe>>(
          future: futureRecipes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Indicateur de chargement
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Affichage de l'erreur
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No recipes found.'); // Pas de recettes
            }

            // Affichage des recettes
            List<Recipe> recipes = snapshot.data!;
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(recipes[index].label),
                  subtitle: Text('Cooking time: ${recipes[index].cookingTime} min'),
                  leading: Image.network(recipes[index].image),
                  onTap: () {
                    // Action à réaliser lors du clic sur une recette
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailScreen(recipe: recipes[index]),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}