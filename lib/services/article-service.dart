import 'dart:convert';
import 'package:equilibromobile/config.dart';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ArticleService {
  
  Future<List<Article>> fetchArticles() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/articles'));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des articles');
    }
  }

}