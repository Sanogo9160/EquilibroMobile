class ApportsNutritionnels {
  final double calories;
  final double proteines;
  final double glucides;
  final double lipides;

  ApportsNutritionnels({
    required this.calories,
    required this.proteines,
    required this.glucides,
    required this.lipides,
  });

  factory ApportsNutritionnels.fromJson(Map<String, dynamic> json) {
    return ApportsNutritionnels(
      calories: json['calories'],
      proteines: json['proteines'],
      glucides: json['glucides'],
      lipides: json['lipides'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'proteines': proteines,
      'glucides': glucides,
      'lipides': lipides,
    };
  }
}
