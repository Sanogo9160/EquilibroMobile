import 'dart:convert';
import 'package:equilibromobile/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ForumService {
  final String _baseUrl = AppConfig.baseUrl;

  // Récupération de la liste des forums
  Future<List<dynamic>> getForums() async {
    final url = Uri.parse('$_baseUrl/forums/obtenir');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception('Token non trouvé. L\'utilisateur doit être authentifié.');
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('Erreur lors de la récupération des forums: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Erreur lors de la récupération des forums: $e');
      rethrow;
    }
  }

  // Récupération des détails d'un forum
  Future<Map<String, dynamic>> getForumDetails(int forumId) async {
    final url = Uri.parse('$_baseUrl/forums/$forumId');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception('Token non trouvé. L\'utilisateur doit être authentifié.');
    }

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erreur lors de la récupération des détails du forum: ${response.statusCode} - ${response.body}');
    }
  }

  // Création d'un forum
  Future<bool> createForum(String nom, String description) async {
    final url = Uri.parse('$_baseUrl/forums/creer');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception('Token non trouvé. L\'utilisateur doit être authentifié.');
    }

    final body = jsonEncode({
      'nom': nom,
      'description': description,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    return response.statusCode == 200;
  }

  // Ajout d'un commentaire à un forum
  Future<bool> addComment(int forumId, String contenu) async {
    final url = Uri.parse('$_baseUrl/forums/$forumId/commentaires');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception('Token non trouvé. L\'utilisateur doit être authentifié.');
    }

    final body = jsonEncode({
      'contenu': contenu,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    return response.statusCode == 200;
  }

// Supprimer un commentaire
Future<bool> deleteComment(int commentId) async {
  final url = Uri.parse('$_baseUrl/commentaires/supprimer/$commentId');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token');

  if (token == null) {
    throw Exception('Token non trouvé. L\'utilisateur doit être authentifié.');
  }

  final response = await http.delete(
    url,
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );

  return response.statusCode == 204; // No Content
}

// Modifier un commentaire
Future<bool> editComment(int commentId, String newContent) async {
  final url = Uri.parse('$_baseUrl/commentaires/modifier/$commentId');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token');

  if (token == null) {
    throw Exception('Token non trouvé. L\'utilisateur doit être authentifié.');
  }

  final body = jsonEncode({
    'contenu': newContent, 
  });

  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: body,
  );

  return response.statusCode == 200; // OK
}

}