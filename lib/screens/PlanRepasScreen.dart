import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../models/repas_suggestion.dart';
import 'RepasDetailScreen.dart';

class PlanRepasScreen extends StatelessWidget {
  final String _defaultAppleImageUrl = 'https://d2eawub7utcl6.cloudfront.net/images/nix-apple-grey.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suggestions de Repas'),
      ),
      body: FutureBuilder<Map<String, List<RepasSuggestion>>>(
        future: _fetchMealSuggestions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune suggestion de repas trouvée.'));
          }

          final meals = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(10.0),
            separatorBuilder: (context, index) => Divider(height: 20),
            itemCount: meals.keys.length,
            itemBuilder: (context, index) {
              String mealType = meals.keys.elementAt(index);
              List<RepasSuggestion> mealSuggestions = meals[mealType]!;
              return _buildMealSection(mealType, mealSuggestions, context);
            },
          );
        },
      ),
    );
  }

  Future<Map<String, List<RepasSuggestion>>> _fetchMealSuggestions() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception("Utilisateur non authentifié.");
    }

    final profileResponse = await _makeRequest('/profils-de-sante/mon-profil', token);
    final profilId = profileResponse['id'];

    final suggestionsResponse = await _makeRequest('/profils-de-sante/plan-repas/$profilId', token);
    return _getRepasSuggestions(suggestionsResponse);
  }

  Future<Map<String, dynamic>> _makeRequest(String endpoint, String token) async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}$endpoint'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erreur lors de la requête HTTP. Code: ${response.statusCode}');
    }
  }

  Map<String, List<RepasSuggestion>> _getRepasSuggestions(Map<String, dynamic> data) {
    return {
      'Petit-dejeuner': (data['petitDejeuner'] ?? []).map((meal) => RepasSuggestion.fromJson(meal)).toList().cast<RepasSuggestion>(),
      'Dejeuner': (data['dejeuner'] ?? []).map((meal) => RepasSuggestion.fromJson(meal)).toList().cast<RepasSuggestion>(),
      'Diner': (data['diner'] ?? []).map((meal) => RepasSuggestion.fromJson(meal)).toList().cast<RepasSuggestion>(),
    };
  }

  Widget _buildMealSection(String title, List<RepasSuggestion> meals, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: meals.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RepasDetailScreen(meal: meals[index]),
                  ),
                );
              },
              child: _buildMealCard(meals[index]),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMealCard(RepasSuggestion suggestion) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: suggestion.photo.isNotEmpty && suggestion.photo != _defaultAppleImageUrl
                  ? CachedNetworkImage(
                      imageUrl: suggestion.photo,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Image.network(_defaultAppleImageUrl, width: 80, height: 80),
                    )
                  : Image.network(_defaultAppleImageUrl, width: 80, height: 80),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(suggestion.foodName, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text('${suggestion.servingQty} ${suggestion.servingUnit}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}