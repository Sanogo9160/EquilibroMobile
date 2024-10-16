class RapportProgression {
  final int id;
  final DateTime date;
  final String contenu;

  RapportProgression({
    required this.id,
    required this.date,
    required this.contenu,
  });

  factory RapportProgression.fromJson(Map<String, dynamic> json) {
    return RapportProgression(
      id: json['id'],
      date: DateTime.parse(json['date']),
      contenu: json['contenu'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'contenu': contenu,
    };
  }
}
