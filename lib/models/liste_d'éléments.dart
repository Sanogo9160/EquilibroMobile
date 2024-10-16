import 'liste_de_courses.dart';

class ElementList {
  final int id;
  final String nom;
  final int quantite;
  final String unite;
  final ListeDeCourses listeDeCourses;

  ElementList({
    required this.id,
    required this.nom,
    required this.quantite,
    required this.unite,
    required this.listeDeCourses,
  });

  factory ElementList.fromJson(Map<String, dynamic> json) {
    return ElementList(
      id: json['id'],
      nom: json['nom'],
      quantite: json['quantite'],
      unite: json['unite'],
      listeDeCourses: ListeDeCourses.fromJson(json['listeDeCourses']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'quantite': quantite,
      'unite': unite,
      'listeDeCourses': listeDeCourses.toJson(),
    };
  }
}
