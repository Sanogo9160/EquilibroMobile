import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart'; // Assurez-vous que la baseUrl est définie dans config.dart

class ProfilDeSanteService {
  static const String baseUrl = AppConfig.baseUrl + "/api/profils-de-sante";

  // Méthode pour récupérer le profil de l'utilisateur connecté
  Future<Map<String, dynamic>?> obtenirMonProfil() async {
    // Récupérer le token JWT depuis SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null) {
      print("Erreur : Aucun token JWT trouvé. Veuillez vous connecter.");
      throw Exception("Utilisateur non authentifié.");
    }

    print('Token JWT utilisé : $token'); // Debug pour s’assurer que le token est correct

    try {
      // Envoyer une requête GET avec le token dans le header Authorization
      final response = await http.get(
        Uri.parse('$baseUrl/mon-profil'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Ajout du token JWT correctement formaté
        },
      );

      print("Réponse API : ${response.statusCode}");
      print("Corps de la réponse : ${response.body}");

      if (response.statusCode == 200) {
        // Retourner les données du profil sous forme de Map
        return jsonDecode(response.body);
      } else {
        print("Erreur lors de la récupération du profil : ${response.body}");
        return null;
      }
    } catch (e) {
      print("Erreur de connexion à l'API : $e");
      return null;
    }
  }
}
