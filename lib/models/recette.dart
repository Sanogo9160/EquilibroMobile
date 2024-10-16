
class Recette {
  final String label;
  final String url;
  final String source;
  final double calories;
  final double carbs;
  final double fat;
  final double protein;
  final List<String> ingredients;

  Recette({
  required this.label,
  required this.url,
  required this.source,
  required this.calories,
  required this.carbs,
  required this.fat,
  required this.protein,
  required this.ingredients,
  });

  factory Recette.fromJson(Map<String, dynamic> json) {
  return Recette(
  label: json['label'],
  url: json['url'],
  source: json['source'],
  calories: json['calories'],
  carbs: json['carbs'],
  fat: json['fat'],
  protein: json['protein'],
  ingredients: List<String>.from(json['ingredients']),
  );
  }
  }

