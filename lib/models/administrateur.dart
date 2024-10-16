
import 'package:equilibromobile/models/utilisateur.dart';

class Administrateur extends Utilisateur {

  Administrateur({
    int? id,
    required String nom,
    required String email,
    required String motDePasse,
    String? telephone,
    double? poids,
    double? taille,
    int? age,
    String? sexe,
  }) : super(
    id: id,
    nom: nom,
    email: email,
    motDePasse: motDePasse,
    telephone: telephone,
    poids: poids,
    taille: taille,
    age: age,
    sexe: sexe,
  );

  factory Administrateur.fromJson(Map<String, dynamic> json) {
    return Administrateur(
      id: json['id'],
      nom: json['nom'],
      email: json['email'],
      motDePasse: json['motDePasse'],
      telephone: json['telephone'],
      poids: json['poids']?.toDouble(),
      taille: json['taille']?.toDouble(),
      age: json['age'],
      sexe: json['sexe'],
    );
  }

}
