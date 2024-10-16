class Hydratation {
  final int id;
  final double quantite;
  final DateTime date;

  Hydratation({
    required this.id,
    required this.quantite,
    required this.date,
  });

  factory Hydratation.fromJson(Map<String, dynamic> json) {
    return Hydratation(
      id: json['id'],
      quantite: json['quantite']?.toDouble() ?? 0.0,
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantite': quantite,
      'date': date.toIso8601String(),
    };
  }
}
