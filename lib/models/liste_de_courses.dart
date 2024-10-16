import "liste_d'éléments.dart";

class ListeDeCourses {
  final int id;
  final DateTime dateCreation;
  final List<ElementList> elementsList;

  ListeDeCourses({
    required this.id,
    required this.dateCreation,
    required this.elementsList,
  });

  factory ListeDeCourses.fromJson(Map<String, dynamic> json) {
    var list = json['elementsList'] as List;
    List<ElementList> elementsList =
    list.map((i) => ElementList.fromJson(i)).toList();

    return ListeDeCourses(
      id: json['id'],
      dateCreation: DateTime.parse(json['dateCreation']),
      elementsList: elementsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateCreation': dateCreation.toIso8601String(),
      'elementsList': elementsList.map((e) => e.toJson()).toList(),
    };
  }
}
