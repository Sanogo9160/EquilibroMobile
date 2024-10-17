import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    primarySwatch: Colors.teal,
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF00796B),
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF00796B),
      selectedItemColor: Colors.white, // Couleur de texte sélectionné
      unselectedItemColor: Colors.white60, // Couleur de texte non sélectionné
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white), // Texte en blanc
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white), // Titre en blanc
    ),
  );

  static final ThemeData dark = ThemeData(
    primarySwatch: Colors.teal,
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF004D40),
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF004D40),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white), // Texte en blanc
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white), // Titre en blanc
    ),
  );
}