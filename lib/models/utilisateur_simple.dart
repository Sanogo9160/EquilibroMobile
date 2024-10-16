

import 'package:equilibromobile/models/utilisateur.dart';

class UtilisateurSimple extends Utilisateur {
  UtilisateurSimple({
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

  factory UtilisateurSimple.fromJson(Map<String, dynamic> json) {
  return UtilisateurSimple(
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


