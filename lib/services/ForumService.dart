import 'dart:convert';
import 'package:equilibromobile/config.dart';
import 'package:equilibromobile/models/commentaire.dart';
import 'package:equilibromobile/models/forum.dart';
import 'package:equilibromobile/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ForumService {
  final String baseUrl = AppConfig.baseUrl;

  Future<List<Forum>> obtenirTousForums() async {
    final token = await AuthService().getToken(); // Récupérer le token
    final response = await http.get(
      Uri.parse('$baseUrl/forums/liste'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json; charset=utf-8", // Spécifier l'encodage UTF-8
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes)); // Décoder les données en UTF-8
      return jsonResponse.map((forum) => Forum.fromJson(forum)).toList();
    } else {
      throw Exception('Échec de chargement des forums');
    }
  }

  Future<List<Commentaire>> obtenirCommentairesParForum(int forumId) async {
    final token = await AuthService().getToken(); // Récupérer le token
    final response = await http.get(
      Uri.parse('$baseUrl/commentaires/$forumId'),
      headers: {
        "Authorization": "Bearer $token", // Ajout du token dans l'en-tête
        "Content-Type": "application/json; charset=utf-8", // Spécifier l'encodage UTF-8
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes)); // Décoder les données en UTF-8
      return jsonResponse.map((commentaire) => Commentaire.fromJson(commentaire)).toList();
    } else {
      throw Exception('Échec de chargement des commentaires');
    }
  }

  Future<Commentaire> creerCommentaire(Commentaire commentaire) async {
    final token = await AuthService().getToken(); // Récupérer le token
    final response = await http.post(
      Uri.parse('$baseUrl/commentaires/ajouter'),
      headers: {
        "Authorization": "Bearer $token", 
        "Content-Type": "application/json; charset=utf-8", //  l'encodage UTF-8
      },
      body: utf8.encode(json.encode({ 
        'contenu': commentaire.contenu,
        'date': commentaire.date.toIso8601String(),
        'forum': {'id': commentaire.forum.id}
      })),
    );

    if (response.statusCode == 201) {
      return Commentaire.fromJson(json.decode(utf8.decode(response.bodyBytes))); 
    } else {
      throw Exception('Échec de création du commentaire');
    }
  }
}