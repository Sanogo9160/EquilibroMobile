import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';
import '../services/auth_service.dart';

class AjouterDisponibiliteScreen extends StatefulWidget {
  @override
  _AjouterDisponibiliteScreenState createState() =>
      _AjouterDisponibiliteScreenState();
}

class _AjouterDisponibiliteScreenState
    extends State<AjouterDisponibiliteScreen> {
  DateTime? _dateDebut;
  DateTime? _dateFin;

  Future<void> ajouterDisponibilite() async {
    final authService = AuthService();
    String? token = await authService.getToken();
    int? dieteticienId = await authService.getUtilisateurId();

    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/disponibilites/ajouter'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "dieteticienId": dieteticienId,
        "dateDebut": _dateDebut?.toIso8601String(),
        "dateFin": _dateFin?.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Disponibilité ajoutée avec succès')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter Disponibilité')),
      body: Column(
        children: [
          ListTile(
            title: Text(_dateDebut == null
                ? 'Choisir date de début'
                : 'Début: $_dateDebut'),
            trailing: Icon(Icons.calendar_today),
            onTap: () async {
              DateTime? date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (date != null) setState(() => _dateDebut = date);
            },
          ),
          ListTile(
            title: Text(_dateFin == null
                ? 'Choisir date de fin'
                : 'Fin: $_dateFin'),
            trailing: Icon(Icons.calendar_today),
            onTap: () async {
              DateTime? date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (date != null) setState(() => _dateFin = date);
            },
          ),
          ElevatedButton(
            onPressed: (_dateDebut != null && _dateFin != null)
                ? ajouterDisponibilite
                : null,
            child: Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}
