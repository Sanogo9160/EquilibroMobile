import 'dart:convert';
import 'package:equilibromobile/models/recette.dart';
import 'package:http/http.dart' as http;


class RecetteService {
  final String baseUrl = 'http://localhost:8080/api/recettes'; // URL de votre API

  Future<List<Recette>> fetchRecettes() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Recette.fromJson(json)).toList();
    } else {
      throw Exception('Aucune recettes trouvées');
    }
  }
}