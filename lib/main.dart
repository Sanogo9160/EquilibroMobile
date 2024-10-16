import 'package:equilibromobile/routes.dart';
import 'package:equilibromobile/services/auth_service.dart';
import 'package:equilibromobile/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthService>(
      create: (_) => AuthService(),
      child: MaterialApp(
        title: 'Equilibro',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: '/', // Point d'entrée de l'application
        routes: AppRoutes.routes, // Utilisation des routes définies dans routes.dart
      ),
    );
  }
}