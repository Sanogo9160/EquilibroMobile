import 'dart:convert';
import 'package:equilibromobile/config.dart';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ArticleService {
  
  Future<List<Article>> getArticles() async {
  final response = await http.get(Uri.parse('${AppConfig.baseUrl}/articles/liste'));
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    return (jsonData as List)
        .map((e) => Article.fromJson(e))
        .toList();
  } else {
    throw Exception('Failed to fetch articles');
  }
}

}