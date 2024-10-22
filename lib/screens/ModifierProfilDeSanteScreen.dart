import 'package:equilibromobile/models/allergie.dart';
import 'package:equilibromobile/models/maladie.dart';
import 'package:equilibromobile/models/objectif_sante.dart';
import 'package:equilibromobile/models/preference_alimentaire.dart';
import 'package:equilibromobile/models/utilisateur.dart';
import 'package:flutter/material.dart';
import 'package:equilibromobile/models/profil_sante.dart';
import 'package:equilibromobile/services/profil_de_sante_service.dart';

class ModifierProfilDeSanteScreen extends StatefulWidget {
  final ProfilDeSante profil;

  ModifierProfilDeSanteScreen({required this.profil});

  @override
  _ModifierProfilDeSanteScreenState createState() => _ModifierProfilDeSanteScreenState();
}

class _ModifierProfilDeSanteScreenState extends State<ModifierProfilDeSanteScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late String _maladies;
  late String _objectifs;
  late String _allergies;
  late String _preferencesAlimentaires;

  @override
  void initState() {
    super.initState();
    _maladies = widget.profil.maladies.map((m) => m.nom).join(', ');
    _objectifs = widget.profil.objectifs.map((o) => o.nom).join(', ');
    _allergies = widget.profil.allergies.map((a) => a.nom).join(', ');
    _preferencesAlimentaires = widget.profil.preferencesAlimentaires.map((p) => p.nom).join(', ');
  }

  void _modifierProfil() async {
    if (_formKey.currentState!.validate()) {
      try {
        ProfilDeSante updatedProfil = ProfilDeSante(
          id: widget.profil.id!,
          utilisateur: Utilisateur(
            id: widget.profil.utilisateur.id,
            nom: widget.profil.utilisateur.nom, // Conserver le nom d'origine
            email: widget.profil.utilisateur.email,
            motDePasse: '', 
          ),
          maladies: _maladies.split(', ').asMap().entries.map((entry) {
            int index = entry.key;
            String nom = entry.value;
            return Maladie(id: index + 1, nom: nom); 
          }).toList(),
          objectifs: _objectifs.split(', ').asMap().entries.map((entry) {
            int index = entry.key;
            String nom = entry.value;
            return ObjectifSante(id: index + 1, nom: nom); 
          }).toList(),
          allergies: _allergies.split(', ').asMap().entries.map((entry) {
            int index = entry.key;
            String nom = entry.value;
            return Allergie(id: index + 1, nom: nom); 
          }).toList(),
          preferencesAlimentaires: _preferencesAlimentaires.split(', ').asMap().entries.map((entry) {
            int index = entry.key;
            String nom = entry.value;
            return PreferenceAlimentaire(id: index + 1, nom: nom); 
          }).toList(),
        );

        await ProfilDeSanteService().mettreAJourProfil(widget.profil.id!, updatedProfil);
        Navigator.pop(context); // Retourner à l'écran précédent
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la mise à jour : $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Modifier Profil de Santé')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Retirer le champ de nom
              Text("Nom : ${widget.profil.utilisateur.nom}", style: TextStyle(fontSize: 18)),
              SizedBox(height: 20), // Espacement
              TextFormField(
                initialValue: _maladies,
                decoration: InputDecoration(labelText: 'Maladies', filled: true, fillColor: Colors.black12),
                validator: (value) => value!.isEmpty ? 'Veuillez entrer des maladies' : null,
                onChanged: (value) => _maladies = value,
              ),
              TextFormField(
                initialValue: _objectifs,
                decoration: InputDecoration(labelText: 'Objectifs', filled: true, fillColor: Colors.black12),
                validator: (value) => value!.isEmpty ? 'Veuillez entrer des objectifs' : null,
                onChanged: (value) => _objectifs = value,
              ),
              TextFormField(
                initialValue: _allergies,
                decoration: InputDecoration(labelText: 'Allergies', filled: true, fillColor: Colors.black12),
                validator: (value) => value!.isEmpty ? 'Veuillez entrer des allergies' : null,
                onChanged: (value) => _allergies = value,
              ),
              TextFormField(
                initialValue: _preferencesAlimentaires,
                decoration: InputDecoration(labelText: 'Préférences Alimentaires', filled: true, fillColor: Colors.black12),
                validator: (value) => value!.isEmpty ? 'Veuillez entrer des préférences alimentaires' : null,
                onChanged: (value) => _preferencesAlimentaires = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _modifierProfil,
                child: Text('Mettre à jour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}