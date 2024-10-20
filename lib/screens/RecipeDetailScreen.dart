import 'package:flutter/material.dart';
import 'package:equilibromobile/models/recipe.dart';
import 'package:url_launcher/url_launcher.dart';

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Affichage de l'image de la recette
              Image.network(
                recipe.image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image, size: 100);
                },
              ),
              SizedBox(height: 16.0),

              // Titre de la section Ingrédients
              Text('Ingrédients:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 8.0),

              // Liste des ingrédients
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: recipe.ingredients.map((ingredient) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text('${ingredient.quantity} ${ingredient.name}'),
                  );
                }).toList(),
              ),

              SizedBox(height: 16.0),

              // Temps de cuisson
              Text('Temps de cuisson: ${recipe.cookingTime} minutes', style: TextStyle(fontWeight: FontWeight.bold)),

              SizedBox(height: 16.0),

              // URL de la recette
              Text('URL de la recette:', style: TextStyle(fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () {
                  _launchURL(recipe.url);
                },
                child: Text(
                  recipe.url,
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Méthode pour ouvrir une URL dans le navigateur
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Impossible d\'ouvrir l\'URL $url';
    }
  }
}