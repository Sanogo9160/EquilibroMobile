/*
import 'package:equilibromobile/models/recipe.dart';
import 'package:flutter/material.dart';

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
              // Image de la recette
              recipe.image.isNotEmpty
                  ? Image.network(
                      recipe.image,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.broken_image, size: 100);
                      },
                    )
                  : Icon(Icons.no_photography, size: 100),
              SizedBox(height: 16.0),

              // Ingrédients
              Text('Ingrédients:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: recipe.ingredients.map((ingredient) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(ingredient),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),

              // Temps de cuisson
              Text('Temps de cuisson: ${recipe.cookingTime} minutes', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 16.0),

              // Apports nutritionnels
              if (recipe.nutritionalInfo != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Apports nutritionnels:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ...recipe.nutritionalInfo!.entries.map((entry) {
                      final info = entry.value;
                      return Text('${entry.key}: ${info.quantity} ${info.unit}');
                    }).toList(),
                  ],
                ),
              SizedBox(height: 16.0),

              // Lien vers la recette complète
              GestureDetector(
                onTap: () => _launchURL(recipe.url),
                child: Text(
                  'Voir la recette complète',
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fonction pour ouvrir l'URL
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Impossible d\'ouvrir l\'URL $url';
    }
  }
}

*/
