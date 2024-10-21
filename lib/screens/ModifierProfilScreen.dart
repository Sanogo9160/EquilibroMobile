import 'package:flutter/material.dart';
import 'package:equilibromobile/models/profil_sante.dart';
import 'package:equilibromobile/services/profil_de_sante_service.dart';

class ModifierProfilScreen extends StatefulWidget {
  final ProfilDeSante profil;

  ModifierProfilScreen({required this.profil});

  @override
  _ModifierProfilScreenState createState() => _ModifierProfilScreenState();
}

class _ModifierProfilScreenState extends State<ModifierProfilScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _nom;
  late String _email;

  @override
  void initState() {
    super.initState();
    _nom = widget.profil.utilisateur.nom;
    _email = widget.profil.utilisateur.email;
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Créer un nouvel objet ProfilDeSante avec les données mises à jour
      ProfilDeSante updatedProfil = ProfilDeSante(
        id: widget.profil.id,
        utilisateur: widget.profil.utilisateur.copyWith(nom: _nom, email: _email),
        maladies: widget.profil.maladies,
        objectifs: widget.profil.objectifs,
        allergies: widget.profil.allergies,
        preferencesAlimentaires: widget.profil.preferencesAlimentaires,
      );

      try {
        //await ProfilDeSanteService().mettreAJourProfil(widget.profil.id, updatedProfil);
        Navigator.pop(context); // Retourne à l'écran précédent
      } catch (e) {
        print('Erreur lors de la mise à jour du profil : $e');
        // Afficher un message d'erreur si nécessaire
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
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom'),
                initialValue: _nom,
                onSaved: (value) => _nom = value!,
                validator: (value) => value!.isEmpty ? 'Veuillez entrer un nom' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                initialValue: _email,
                onSaved: (value) => _email = value!,
                validator: (value) => value!.isEmpty ? 'Veuillez entrer un email' : null,
              ),
              // Ajoutez d'autres champs pour les maladies, objectifs, allergies, etc.
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Mettre à Jour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}