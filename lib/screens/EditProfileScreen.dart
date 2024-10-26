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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _nom,
                decoration: const InputDecoration(labelText: 'Nom'),
                style: const TextStyle(color: Colors.black),
                onSaved: (value) => _nom = value ?? '',
              ),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                style: const TextStyle(color: Colors.black),
                onSaved: (value) => _email = value ?? '',
              ),
              TextFormField(
                initialValue: _telephone,
                decoration: const InputDecoration(labelText: 'Téléphone'),
                style: const TextStyle(color: Colors.black),
                onSaved: (value) => _telephone = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nouveau Mot de Passe'),
                style: const TextStyle(color: Colors.black),
                onSaved: (value) => _motDePasse = value,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Sauvegarder'),
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
