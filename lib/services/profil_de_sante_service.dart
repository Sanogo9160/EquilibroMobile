import 'dart:convert';
import 'package:equilibromobile/models/profil_sante.dart';
import 'package:equilibromobile/models/utilisateur.dart';
import 'package:equilibromobile/screens/PlanRepasScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class ProfilDeSanteService {
  static const String baseUrl = AppConfig.baseUrl + "/profils-de-sante";

  Future<Map<String, dynamic>?> obtenirMonProfil() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception("Utilisateur non authentifié.");
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/mon-profil'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur lors de la récupération du profil');
      }
    } catch (e) {
      throw Exception('Erreur de connexion à l\'API : $e');
    }
  }
  
Future<ProfilDeSante> ajouterProfil(ProfilDeSante profil, BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('jwt_token');

  if (token == null) {
    throw Exception("Utilisateur non authentifié.");
  }

  try {
    final response = await http.post(
      Uri.parse('$baseUrl/ajouter'), // URL corrigée
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(profil.toJson()),
    );

    if (response.statusCode == 201) {
      // Profil créé avec succès, naviguer vers PlanRepasScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlanRepasScreen()),
      );
      return ProfilDeSante.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erreur lors de la création du profil: ${response.body}');
    }
  } catch (e) {
    throw Exception('Erreur de connexion à l\'API : $e');
  }
}



Future<ProfilDeSante> mettreAJourProfil(int id, ProfilDeSante profil) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception("Utilisateur non authentifié.");
    }

    final response = await http.put(
      Uri.parse('$baseUrl/modifier/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(profil.toJson()), 
    );

    if (response.statusCode == 200) {
      return ProfilDeSante.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erreur lors de la mise à jour du profil: ${response.body}');
    }
}

  Future<void> supprimerProfil(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception("Utilisateur non authentifié.");
    }

    await http.delete(
      Uri.parse('$baseUrl/supprimer/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  //
  Future<Utilisateur?> obtenirMonUtilisateur() async {
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('jwt_token');

  if (token == null) {
    throw Exception("Utilisateur non authentifié.");
  }

  try {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/utilisateurs/current'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Utilisateur.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erreur lors de la récupération de l\'utilisateur');
    }
  } catch (e) {
    throw Exception('Erreur de connexion à l\'API : $e');
  }
}
  }


