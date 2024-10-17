import 'package:equilibromobile/screens/felicitation-ecran.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';
import 'package:flutter/services.dart';

class InscriptionPage extends StatefulWidget {
  @override
  _InscriptionPageState createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour les champs de saisie
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();
  final TextEditingController _poidsController = TextEditingController();
  final TextEditingController _tailleController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  
  String _sexe = 'Homme'; // Valeur par défaut pour le sexe

  // Fonction pour gérer l'inscription
  Future<void> _inscrireUtilisateur() async {
    if (_formKey.currentState!.validate()) {
      final String nom = _nomController.text;
      final String email = _emailController.text;
      final String telephone = _telephoneController.text;
      final String motDePasse = _motDePasseController.text;
      final double poids = double.parse(_poidsController.text);
      final double taille = double.parse(_tailleController.text);
      final int age = int.parse(_ageController.text);

      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/utilisateurs/ajouter/utilisateur-simple'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'nom': nom,
          'email': email,
          'motDePasse': motDePasse,
          'telephone': telephone,
          'poids': poids,
          'taille': taille,
          'age': age,
          'sexe': _sexe,
          'role': {'id': 3}, // ID du rôle utilisateur
        }),
      );

      if (response.statusCode == 201) {
        // Inscription réussie
        final responseBody = jsonDecode(response.body);
        print('Utilisateur inscrit: ${responseBody['email']}');
        // Naviguer vers la page de félicitations
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FelicitationScreen()),
        );
      } else {
        // Erreur lors de l'inscription
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'inscription : ${response.body}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ... vos champs de formulaire ici ...
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _inscrireUtilisateur,
                  child: Text('S\'inscrire', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Color(0xFF00796B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}