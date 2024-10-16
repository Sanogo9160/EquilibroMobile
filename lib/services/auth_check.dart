import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    final token = await _authService.getToken();
    if (token != null) {
      // Redirige vers AccueilScreen si l'utilisateur est authentifié
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Redirige vers LoginScreen si l'utilisateur n'est pas authentifié
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(), // Affiche un loader en attendant la vérification
      ),
    );
  }
}
