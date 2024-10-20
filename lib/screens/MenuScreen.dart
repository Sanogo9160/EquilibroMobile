import 'package:equilibromobile/models/recipe.dart';
import 'package:equilibromobile/screens/RecipeDetailScreen.dart';
import 'package:equilibromobile/services/recette_service.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<List<Recipe>> futureRecipes;
  final recetteService = RecetteService();

  @override
  void initState() {
    super.initState();
    futureRecipes = recetteService.fetchRecipes("chicken"); // Appel au service pour récupérer les recettes
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
              return Text('Erreur: ${snapshot.error}'); // Gestion des erreurs
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('Aucune recette trouvée.'); // Si aucune recette
            }

            List<Recipe> recipes = snapshot.data!;
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(recipes[index].label),
                  subtitle: Text('Temps de cuisson: ${recipes[index].cookingTime} min'),
                  leading: Image.network(
                    recipes[index].image,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image); // Gestion de l'erreur d'image
                    },
                  ),
                  onTap: () {
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