import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class AuthService extends ChangeNotifier{
  final String _baseUrl = AppConfig.baseUrl;

  // Connexion utilisateur et stockage du token
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
        print('Token JWT récupéré : $token'); // Vérifier que le token est bien récupéré

        // Stocker le token JWT
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

  // Récupération du token JWT depuis SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Déconnexion et suppression du token
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final token = await getToken();
    if (token == null) return null;

    // Décoder le token JWT pour obtenir les données de l'utilisateur
    final payload = _decodeJwt(token);
    return payload;
  }

  Map<String, dynamic>? _decodeJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      return null; // Token mal formé
    }

    // Décoder la partie payload du token
    final payload = parts[1];
    final normalizedPayload = base64Url.normalize(payload);
    final decodedBytes = base64Url.decode(normalizedPayload);
    final decodedString = utf8.decode(decodedBytes);
    return jsonDecode(decodedString);
  }

  

}
