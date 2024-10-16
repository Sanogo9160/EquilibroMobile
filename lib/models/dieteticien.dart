

import 'package:equilibromobile/models/utilisateur.dart';

class Dieteticien extends Utilisateur {
  final String? specialite;

  Dieteticien({
  int? id,
  required String nom,
  required String email,
  required String motDePasse,
  String? telephone,
  double? poids,
  double? taille,
  int? age,
  String? sexe,
  this.specialite,
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

  factory Dieteticien.fromJson(Map<String, dynamic> json) {
  return Dieteticien(
  id: json['id'],
  nom: json['nom'],
  email: json['email'],
  motDePasse: json['motDePasse'],
  telephone: json['telephone'],
  poids: json['poids']?.toDouble(),
  taille: json['taille']?.toDouble(),
  age: json['age'],
  sexe: json['sexe'],
  specialite: json['specialite'],
  );
  }

  @override
  Map<String, dynamic> toJson() {
  final data = super.toJson();
  data['specialite'] = specialite;
  return data;
  }




}
