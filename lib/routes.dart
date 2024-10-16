import 'package:equilibromobile/screens/HomeScreen.dart';
import 'package:equilibromobile/screens/InscriptionScreen.dart';
import 'package:equilibromobile/screens/LoginScreen.dart';
import 'package:equilibromobile/screens/felicitation-ecran.dart';
import 'package:equilibromobile/services/auth_check.dart';
import 'package:flutter/material.dart';


class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    '/': (context) => AuthCheck(),
    '/home': (context) => HomeScreen(),
    '/login': (context) => LoginScreen(),
    '/signup':(context) =>InscriptionPage(),
    '/felicitation': (context) => FelicitationScreen(),

  };
}