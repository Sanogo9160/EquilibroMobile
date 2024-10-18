import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/article.dart';
import '../services/auth_service.dart';

class ArticleService {
  final String baseUrl = AppConfig.baseUrl + "/articles/liste";
  final AuthService _authService = AuthService();

  Future<List<Article>> getArticles() async {
    try {
      // Récupérer le token JWT
      final token = await _authService.getToken();
      if (token == null) throw Exception('Token JWT introuvable');

      // Ajouter le token dans les headers
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Envoyer la requête GET avec les en-têtes
      final response = await http.get(Uri.parse(baseUrl), headers: headers);

      if (response.statusCode == 200) {
        // Décoder le corps de la réponse
        String responseBody = utf8.decode(response.bodyBytes);
        List<dynamic> jsonList = json.decode(responseBody);
        return jsonList.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Erreur: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Erreur lors de la récupération des articles: $e');
      throw Exception('Erreur lors de la récupération des articles');
    }
  }
}
