import 'dart:convert';
import 'package:equilibromobile/config.dart';
import 'package:equilibromobile/models/Recipe.dart';
import 'package:equilibromobile/models/recette.dart';
import 'package:http/http.dart' as http;


class RecetteService {
 
  final String baseUrl = AppConfig.baseUrl;
/*
  Future<List<Recipe>> fetchRecipes(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/recipes?query=$query'));

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((data) => Recipe.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }
  */

  Future<List<Recipe>> fetchRecipes() async {
    final response = await http.get(Uri.parse('$baseUrl/recipes'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Recipe.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }
  
}