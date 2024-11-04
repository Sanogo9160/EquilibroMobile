import 'package:equilibromobile/models/repas_suggestion.dart';
import 'package:flutter/material.dart';

class RepasDetailScreen extends StatelessWidget {
  final RepasSuggestion meal;

  RepasDetailScreen({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Détails du repas"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(meal.foodName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Quantité: ${meal.servingQty} ${meal.servingUnit}"),
            Text("Calories: ${meal.calories.toStringAsFixed(2)} kcal"),
            Text("Lipides: ${meal.fat.toStringAsFixed(2)} g"),
            Text("Glucides: ${meal.carbohydrates.toStringAsFixed(2)} g"),
            Text("Protéines: ${meal.protein.toStringAsFixed(2)} g"),
            
          ],
        ),
      ),
    );
  }
}
