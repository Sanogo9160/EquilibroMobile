class Commentaire {
  final int id;
  final String contenu;
  final String auteur;
  final DateTime dateCreation;

  Commentaire({
    required this.id,
    required this.contenu,
    required this.auteur,
    required this.dateCreation,
  });

  factory Commentaire.fromJson(Map<String, dynamic> json) {
    return Commentaire(
      id: json['id'],
      contenu: json['contenu'],
      auteur: json['auteur']['nomUtilisateur'],
      dateCreation: DateTime.parse(json['dateCreation']),
    );
  }
}
