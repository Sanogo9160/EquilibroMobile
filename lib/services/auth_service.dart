import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; 
import '../config.dart';
import '../models/utilisateur.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = AppConfig.baseUrl;

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "motDePasse": password}),
      );

      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        return true;
      } else {
        print('Échec de la connexion : ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erreur lors de la connexion : $e');
      return false;
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  // Récupération de l'utilisateur à partir du token JWT
  Future<Utilisateur?> getCurrentUser() async {
    final token = await getToken();
    if (token == null) return null;

    final url = Uri.parse('$_baseUrl/utilisateurs/current');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return Utilisateur.fromJson(jsonDecode(response.body));
    } else {
      print('Erreur lors de la récupération de l\'utilisateur : ${response.body}');
      return null;
    }
  }

  // Méthode pour obtenir l'identifiant utilisateur à partir du token
  Future<int?> getUtilisateurId() async {
    final token = await getToken();
    if (token == null) return null;

    final decodedToken = _decodeJwt(token);
    return decodedToken?['id']; // Assurez-vous que 'id' est la clé correcte dans le payload du token
  }

  Map<String, dynamic>? _decodeJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;

    final payload = parts[1];
    final normalizedPayload = base64Url.normalize(payload);
    final decodedBytes = base64Url.decode(normalizedPayload);
    final decodedString = utf8.decode(decodedBytes);

    return jsonDecode(decodedString);
  }

  Future<bool> updateUserProfile(
      String nom, String email, String? telephone, String? motDePasse) async {
    final token = await getToken();
    if (token == null) return false;

    final url = Uri.parse('$_baseUrl/utilisateurs/update'); 
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'nom': nom,
          'email': email,
          'telephone': telephone,
          'motDePasse': motDePasse,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erreur lors de la mise à jour du profil : ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erreur lors de la mise à jour du profil : $e');
      return false;
    }
  }
}
