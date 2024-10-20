import 'package:flutter/material.dart';

class EcranPrincipal extends StatefulWidget {
  @override
  _EcranPrincipalState createState() => _EcranPrincipalState();
}

class _EcranPrincipalState extends State<EcranPrincipal> {
  @override
  void initState() {
    super.initState();
    // Redirige vers la page de connexion après 5 secondes
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16.0), // Espace en haut
            Text(
              'Bienvenue',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00796B),
              ),
            ),
            SizedBox(height: 16.0), // Espace entre le texte et l'image
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/images/page.png',
                  width: 350.0,
                  height: 150.0,
                ),
              ),
            ),
            SizedBox(height: 16.0), // Espace entre l'image et le texte de description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Equilibro, ',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00796B),
                          ),
                        ),
                        TextSpan(
                          text: 'votre plateforme de menus diététiques personnalisés. Que vous soyez concerné par le diabète, l\'hypertension, ou d\'autres besoins nutritionnels adaptés, nous proposons des conseils nutritionnels et un accès à des nutritionnistes certifiés. Découvrez les bienfaits de nos clients grâce à une ',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'alimentation saine et équilibrée.',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00796B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}