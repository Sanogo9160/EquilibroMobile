import 'package:flutter/material.dart';

class EcranPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenue'),
        backgroundColor: Color(0xFF00796B), // Couleur de l'AppBar
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Equilibro, votre plateforme de menus diététiques personnalisés.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              "Que vous soyez concerné par le diabète, l'hypertension, ou d'autres besoins, nous proposons des conseils nutritionnels adaptés et l'accès à des nutritionnistes certifiés. Découvrez les bienfaits de nos clients grâce à nos guides interactifs et venez pour une alimentation saine et équilibrée.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}