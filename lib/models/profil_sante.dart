class ProfilDeSante {
  final int id;
  final List<String> maladies;
  final List<String> objectifs;
  final List<String> allergies;
  final List<String> preferencesAlimentaires;

  ProfilDeSante({
    required this.id,
    required this.maladies,
    required this.objectifs,
    required this.allergies,
    required this.preferencesAlimentaires,
  });

  // Getters
  List<String> get getMaladies => maladies;
  List<String> get getObjectifs => objectifs;
  List<String> get getAllergies => allergies;
  List<String> get getPreferencesAlimentaires => preferencesAlimentaires;

  factory ProfilDeSante.fromJson(Map<String, dynamic> json) {
    return ProfilDeSante(
      id: json['id'],
      maladies: List<String>.from(json['maladies']),
      objectifs: List<String>.from(json['objectifs']),
      allergies: List<String>.from(json['allergies']),
      preferencesAlimentaires: List<String>.from(json['preferencesAlimentaires']),
    );
  }
}