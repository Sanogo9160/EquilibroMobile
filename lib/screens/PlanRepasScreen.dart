import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class PlanRepasScreen extends StatefulWidget {
  @override
  _PlanRepasScreenState createState() => _PlanRepasScreenState();
}

class _PlanRepasScreenState extends State<PlanRepasScreen> {
  List<dynamic> _mealPlan = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchMealPlan();
  }

  Future<void> _fetchMealPlan() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null) {
      setState(() {
        _errorMessage = "Utilisateur non authentifié.";
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/plan-repas'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _mealPlan = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Erreur lors de la récupération du plan de repas';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur de connexion à l\'API : $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Plan de Repas'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _mealPlan.isEmpty
                  ? Center(child: Text('Aucun plan de repas disponible.'))
                  : ListView.builder(
                      itemCount: _mealPlan.length,
                      itemBuilder: (context, index) {
                        final meal = _mealPlan[index];
                        print(meal['image']); 
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: ListTile(
                            leading: CachedNetworkImage(
                              imageUrl: meal['image'] ?? '',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.broken_image, size: 60),
                            ),
                            title: Text(meal['label'] ?? 'Recette inconnue'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Temps de cuisson: ${meal['cookingTime'] ?? 0} minutes',
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Ingrédients: ${meal['ingredients']?.join(', ') ?? 'Aucun'}',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
