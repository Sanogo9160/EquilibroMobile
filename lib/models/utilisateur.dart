import 'dart:convert';

class Utilisateur {
  final int? id;
  final String nom;
  final String email;
  final String motDePasse;
  final String? telephone;
  final double? poids;
  final double? taille;
  final int? age;
  final String? sexe;
  final Role? role;
  final ProfilDeSante? profilDeSante;

  Utilisateur({
    this.id,
    required this.nom,
    required this.email,
    required this.motDePasse,
    this.telephone,
    this.poids,
    this.taille,
    this.age,
    this.sexe,
    this.role,
    this.profilDeSante,
  });

  // Méthode pour créer un Utilisateur à partir d'un JSON
  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id'],
      nom: json['nom'],
      email: json['email'],
      motDePasse: json['motDePasse'],
      telephone: json['telephone'],
      poids: json['poids']?.toDouble(),
      taille: json['taille']?.toDouble(),
      age: json['age'],
      sexe: json['sexe'],
      role: json['role'] != null ? Role.fromJson(json['role']) : null,
      profilDeSante: json['profilDeSante'] != null ? ProfilDeSante.fromJson(json['profilDeSante']) : null,
    );
  }

  // Méthode pour convertir un Utilisateur en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'email': email,
      'motDePasse': motDePasse,
      'telephone': telephone,
      'poids': poids,
      'taille': taille,
      'age': age,
      'sexe': sexe,
      'role': role?.toJson(),
      'profilDeSante': profilDeSante?.toJson(),
    };
  }

  copyWith({required String nom, required String email}) {}
}

// Exemple de classe Role
class Role {
  final int? id;
  final String nom;

  Role({this.id, required this.nom});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      nom: json['nom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
    };
  }
}

// Exemple de classe ProfilDeSante
class ProfilDeSante {
  final int? id;
  final String? details; // Ajoutez d'autres champs nécessaires

  ProfilDeSante({this.id, this.details});

  factory ProfilDeSante.fromJson(Map<String, dynamic> json) {
    return ProfilDeSante(
      id: json['id'],
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'details': details,
    };
  }
}