import 'dart:convert';
import 'package:equilibromobile/config.dart';
import 'package:equilibromobile/models/recipe.dart';
import 'package:http/http.dart' as http;


class RecetteService {
 
 final String apiUrl = '${AppConfig.baseUrl}/recipes'; // URL de base de l'API backend
Future<Map<String, List<Recipe>>> fetchRecipes() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((key, value) {
        List<Recipe> recipes = List<Recipe>.from(
          value.map((data) => Recipe.fromJson(data)),
        );
        return MapEntry(key, recipes);
      });
    } else {
      throw Exception('Erreur lors du chargement des recettes');
    }
  }


}