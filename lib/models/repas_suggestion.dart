class RepasSuggestion {
  final String foodName;
  final int servingQty;
  final String servingUnit;
  final String photo;
  final double calories;
  final double fat;
  final double carbohydrates;
  final double protein;

  RepasSuggestion({
    required this.foodName,
    required this.servingQty,
    required this.servingUnit,
    required this.photo,
    required this.calories,
    required this.fat,
    required this.carbohydrates,
    required this.protein,
  });

  factory RepasSuggestion.fromJson(Map<String, dynamic> json) {
    return RepasSuggestion(
      foodName: json['foodName'] ?? '',
      servingQty: json['servingQty'] ?? 1,
      servingUnit: json['servingUnit'] ?? '',
      photo: json['photo'] ?? '',
      calories: json['nutritionInfo']?['calories']?.toDouble() ?? 0.0,
      fat: json['nutritionInfo']?['fat']?.toDouble() ?? 0.0,
      carbohydrates: json['nutritionInfo']?['carbohydrates']?.toDouble() ?? 0.0,
      protein: json['nutritionInfo']?['protein']?.toDouble() ?? 0.0,
    );
  }
}
