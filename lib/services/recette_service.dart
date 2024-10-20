import 'dart:convert';
import 'package:equilibromobile/config.dart';
import 'package:equilibromobile/models/recipe.dart';
import 'package:http/http.dart' as http;


class RecetteService {
 
  final String apiUrl = '${AppConfig.baseUrl}/recipes'; // URL de base de l'API backend

  Future<List<Recipe>> fetchRecipes(String query) async {
    final response = await http.get(Uri.parse('$apiUrl?query=$query'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => Recipe.fromJson(data)).toList();
    } else {
      throw Exception('Erreur lors du chargement des recettes');
    }
  }
  
}