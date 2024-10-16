import 'package:flutter/material.dart';

class AppTheme {
  // Thème clair
  static final ThemeData light = ThemeData(
    primarySwatch: Colors.teal, // Couleur principale
    brightness: Brightness.light, // Luminosité du thème
    visualDensity: VisualDensity.adaptivePlatformDensity, // Gestion de l'espacement
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.teal, // Couleur de l'AppBar
      foregroundColor: Colors.white, // Couleur du texte de l'AppBar
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black), // Style du texte par défaut
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Style des titres
    ),
    // Ajoutez d'autres personnalisations de thème selon vos besoins
  );

  // Thème sombre
  static final ThemeData dark = ThemeData(
    primarySwatch: Colors.teal, // Couleur principale pour le thème sombre
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF00796B), // Couleur de l'AppBar en mode sombre
      foregroundColor: Colors.white,
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white), // Style du texte par défaut en mode sombre
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
  );
}