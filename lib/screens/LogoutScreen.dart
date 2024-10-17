import 'package:flutter/material.dart';

class LogoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Déconnexion'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Retourner à l'écran précédent
          },
          child: Text('Se déconnecter'),
        ),
      ),
    );
  }
}