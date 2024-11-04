import 'package:flutter/material.dart';
import 'package:equilibromobile/services/auth_service.dart';
import 'package:equilibromobile/models/utilisateur.dart';

class EditProfileScreen extends StatefulWidget {
  final Utilisateur utilisateur;

  EditProfileScreen({required this.utilisateur});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  late String _nom;
  late String _email;
  String? _telephone;
  String? _motDePasse;

  @override
  void initState() {
    super.initState();
    _nom = widget.utilisateur.nom;
    _email = widget.utilisateur.email;
    _telephone = widget.utilisateur.telephone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le Profil'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        color: Colors.teal[50],
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _nom,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  labelStyle: TextStyle(color: Colors.teal),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                onSaved: (value) => _nom = value ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.teal),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                onSaved: (value) => _email = value ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _telephone,
                decoration: InputDecoration(
                  labelText: 'Téléphone',
                  labelStyle: TextStyle(color: Colors.teal),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                onSaved: (value) => _telephone = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nouveau Mot de Passe',
                  labelStyle: TextStyle(color: Colors.teal),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                onSaved: (value) => _motDePasse = value,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Sauvegarder'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Coins carrés
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Récupère l'ID de l'utilisateur
      final utilisateurId = await _authService.getUtilisateurId();
      if (utilisateurId == null) {
        print("Erreur : ID utilisateur non trouvé");
        return;
      }

      final success = await _authService.updateUserProfile(
        utilisateurId,
        _nom,
        _email,
        _telephone,
        _motDePasse,
      );

      if (success) {
        Navigator.pop(context);
      } else {
        print("Erreur lors de la mise à jour du profil.");
      }
    }
  }
}