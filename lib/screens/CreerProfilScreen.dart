import 'package:equilibromobile/screens/PlanRepasScreen.dart';
import 'package:flutter/material.dart';
import 'package:equilibromobile/models/allergie.dart';
import 'package:equilibromobile/models/maladie.dart';
import 'package:equilibromobile/models/objectif_sante.dart';
import 'package:equilibromobile/models/preference_alimentaire.dart';

import 'package:equilibromobile/models/profil_sante.dart' as sante;
import 'package:equilibromobile/models/utilisateur.dart';
import '../services/profil_de_sante_service.dart';

class CreerProfilScreen extends StatefulWidget {
  @override
  _CreerProfilScreenState createState() => _CreerProfilScreenState();
}

class _CreerProfilScreenState extends State<CreerProfilScreen> {
  List<String> _maladies = ['Diabète', 'Hypertension', 'Aucune'];
  List<String> _objectifs = ['Perte de poids', 'Garder la forme', 'Augmenter la masse musculaire'];
  List<String> _allergies = ['Arachides', 'Lait', 'Gluten', 'Aucune'];
  List<String> _preferencesAlimentaires = ['Végétarien', 'Carnivore', 'Sans Gluten'];

  String? _selectedMaladie;
  String? _selectedObjectif;
  String? _selectedAllergie;
  String? _selectedPreferenceAlimentaire;

  final _formKey = GlobalKey<FormState>();

  Future<void> _submitProfil() async {
    if (_formKey.currentState!.validate()) {
      final List<Maladie> maladiesList = _selectedMaladie != null && _selectedMaladie != 'Aucune'
          ? [Maladie(id: 1, nom: _selectedMaladie!)]
          : [];
      final List<ObjectifSante> objectifsList = _selectedObjectif != null
          ? [ObjectifSante(id: 1, nom: _selectedObjectif!)]
          : [];
      final List<Allergie> allergiesList = _selectedAllergie != null && _selectedAllergie != 'Aucune'
          ? [Allergie(id: 1, nom: _selectedAllergie!)]
          : [];
      final List<PreferenceAlimentaire> preferencesAlimentairesList = _selectedPreferenceAlimentaire != null
          ? [PreferenceAlimentaire(id: 1, nom: _selectedPreferenceAlimentaire!)]
          : [];

      final profil = sante.ProfilDeSante(
        maladies: maladiesList,
        objectifs: objectifsList,
        allergies: allergiesList,
        preferencesAlimentaires: preferencesAlimentairesList,
        utilisateur: Utilisateur(id: 1, nom: 'Utilisateur Test', email: '', motDePasse: ''),
      );

try {
  // Appel au service pour ajouter le profil avec le context
  await ProfilDeSanteService().ajouterProfil(profil, context);

  // Afficher un message de succès
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Profil créé avec succès!')),
  );

  // Redirection vers l'écran du plan de repas
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PlanRepasScreen()),
  );
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Erreur lors de la création du profil: $e')),
  );
}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer un Profil de Santé')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Sélectionner une maladie'),
                value: _selectedMaladie,
                items: _maladies.map((String maladie) {
                  return DropdownMenuItem<String>(
                    value: maladie,
                    child: Text(maladie),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMaladie = value;
                  });
                },
                validator: (value) => value == null ? 'Veuillez sélectionner une maladie' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Sélectionner un objectif'),
                value: _selectedObjectif,
                items: _objectifs.map((String objectif) {
                  return DropdownMenuItem<String>(
                    value: objectif,
                    child: Text(objectif),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedObjectif = value;
                  });
                },
                validator: (value) => value == null ? 'Veuillez sélectionner un objectif' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Sélectionner une allergie'),
                value: _selectedAllergie,
                items: _allergies.map((String allergie) {
                  return DropdownMenuItem<String>(
                    value: allergie,
                    child: Text(allergie),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAllergie = value;
                  });
                },
                validator: (value) => value == null ? 'Veuillez sélectionner une allergie' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Préférences Alimentaires'),
                value: _selectedPreferenceAlimentaire,
                items: _preferencesAlimentaires.map((String preference) {
                  return DropdownMenuItem<String>(
                    value: preference,
                    child: Text(preference),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPreferenceAlimentaire = value;
                  });
                },
                validator: (value) => value == null ? 'Veuillez sélectionner une préférence alimentaire' : null,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitProfil,
                child: Text('Créer le Profil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
