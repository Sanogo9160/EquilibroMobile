import 'package:equilibromobile/models/allergie.dart';
import 'package:equilibromobile/models/maladie.dart';
import 'package:equilibromobile/models/objectif_sante.dart';
import 'package:equilibromobile/models/preference_alimentaire.dart';
import 'package:equilibromobile/models/profil_sante.dart';
import 'package:equilibromobile/services/profil_de_sante_service.dart';
import 'package:equilibromobile/services/auth_service.dart';
import 'package:flutter/material.dart';

class CreerProfilScreen extends StatefulWidget {
  @override
  _CreerProfilScreenState createState() => _CreerProfilScreenState();
}

class _CreerProfilScreenState extends State<CreerProfilScreen> {
  String _healthObjective = '';
  String _healthCondition = 'Je n\'ai pas de maladie';
  String _dietPreference = '';
  String _allergies = '';

  final ProfilDeSanteService _profilDeSanteService = ProfilDeSanteService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Création du Profil de Santé'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Texte d'introduction
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Avant de commencer, veuillez remplir les informations suivantes pour créer votre profil de santé.',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Ces informations nous aideront à vous proposer des aliments adaptées à vos bésoins/objectifs en toute sécurité et rapidement.',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),

              // Champ Objectif de Santé avec bordure
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Objectif de Santé',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Indiquez votre objectif de santé',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _healthObjective = value;
                        });
                      },
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),

              // Champ Maladie avec bordure
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Type de Maladie',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    RadioListTile(
                      title: Text('Je n\'ai pas de maladie'),
                      value: 'Je n\'ai pas de maladie',
                      groupValue: _healthCondition,
                      onChanged: (value) {
                        setState(() {
                          _healthCondition = value.toString();
                        });
                      },
                      activeColor: Colors.teal,
                    ),
                    RadioListTile(
                      title: Text('Diabète'),
                      value: 'Diabète',
                      groupValue: _healthCondition,
                      onChanged: (value) {
                        setState(() {
                          _healthCondition = value.toString();
                        });
                      },
                      activeColor: Colors.teal,
                    ),
                    RadioListTile(
                      title: Text('Hypertension'),
                      value: 'Hypertension',
                      groupValue: _healthCondition,
                      onChanged: (value) {
                        setState(() {
                          _healthCondition = value.toString();
                        });
                      },
                      activeColor: Colors.teal,
                    ),
                  ],
                ),
              ),

              // Préférences Alimentaires avec bordure
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Préférences Alimentaires',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    RadioListTile(
                      title: Text('Végétarien'),
                      value: 'Végétarien',
                      groupValue: _dietPreference,
                      onChanged: (value) {
                        setState(() {
                          _dietPreference = value.toString();
                        });
                      },
                      activeColor: Colors.teal,
                    ),
                    RadioListTile(
                      title: Text('Carnivore'),
                      value: 'Carnivore',
                      groupValue: _dietPreference,
                      onChanged: (value) {
                        setState(() {
                          _dietPreference = value.toString();
                        });
                      },
                      activeColor: Colors.teal,
                    ),
                  ],
                ),
              ),

              // Allergies avec bordure
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Allergies',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Indiquez vos allergies',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _allergies = value;
                        });
                      },
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),

              // Bouton avec bordure et largeur étendue
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Récupérer l'utilisateur connecté via AuthService
                    final utilisateur = await _authService.getCurrentUser();
                    if (utilisateur == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Utilisateur non authentifié')),
                      );
                      return;
                    }

                    // Création de l'objet ProfilDeSante avec les données collectées
                    var profilDeSante = ProfilDeSante(
                      maladies: [Maladie(id: 1, nom: _healthCondition)],
                      objectifs: [ObjectifSante(id: 1, nom: _healthObjective)],
                      allergies: [Allergie(id: 1, nom: _allergies)],
                      preferencesAlimentaires: [PreferenceAlimentaire(id: 1, nom: _dietPreference)],
                      utilisateur: utilisateur, // Utilisateur récupéré
                    );

                    // Appel du service pour ajouter le profil
                    try {
                      await _profilDeSanteService.ajouterProfil(profilDeSante, context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Profil de santé ajouté avec succès!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erreur lors de l\'ajout du profil: $e')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Créer un profil',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
