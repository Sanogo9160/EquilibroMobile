class Message {
  final int id;
  final String contenu;
  final DateTime dateCreation;

  Message({required this.id, required this.contenu, required this.dateCreation});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      contenu: json['contenu'],
      dateCreation: DateTime.parse(json['dateCreation']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contenu': contenu,
      'dateCreation': dateCreation.toIso8601String(),
    };
  }
}
