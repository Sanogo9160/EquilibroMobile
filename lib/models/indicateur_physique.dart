class IndicateurPhysique {
  final int id;
  final double poids; // Poids de l'utilisateur
  final double glycemie; // Taux de glycémie
  final String pressionArterielle; // Pression artérielle
  final DateTime date; // Date de l'indicateur

  IndicateurPhysique({
    required this.id,
    required this.poids,
    required this.glycemie,
    required this.pressionArterielle,
    required this.date,
  });

  factory IndicateurPhysique.fromJson(Map<String, dynamic> json) {
    return IndicateurPhysique(
      id: json['id'],
      poids: json['poids'],
      glycemie: json['glycemie'],
      pressionArterielle: json['pressionArterielle'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'poids': poids,
      'glycemie': glycemie,
      'pressionArterielle': pressionArterielle,
      'date': date.toIso8601String(),
    };
  }
}
