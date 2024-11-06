import 'dart:convert';
import 'package:equilibromobile/config.dart';
import 'package:equilibromobile/models/dieteticien.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../services/auth_service.dart';

class DisponibilitesScreen extends StatefulWidget {
  final Dieteticien dieteticien;

  DisponibilitesScreen({required this.dieteticien});

  @override
  _DisponibilitesScreenState createState() => _DisponibilitesScreenState();
}

class _DisponibilitesScreenState extends State<DisponibilitesScreen> {
  List<dynamic> _disponibilites = [];

  @override
  void initState() {
    super.initState();
    _fetchDisponibilites();
  }

  // Fetch availability
  Future<void> _fetchDisponibilites() async {
    try {
      final authService = AuthService();
      String? token = await authService.getToken();

      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/disponibilites/dieteticien/${widget.dieteticien.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          _disponibilites = json.decode(response.body);
        });
      } else {
        throw Exception('Erreur lors du chargement des disponibilités');
      }
    } catch (e) {
      print('Erreur de chargement: $e');
    }
  }

  Future<void> reserverConsultation(dynamic disponibilite) async {
    final authService = AuthService();
    String? token = await authService.getToken();
    int? utilisateurId = await authService.getUtilisateurId();

    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/consultations/reserver'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "utilisateurId": utilisateurId,
        "dieteticienId": widget.dieteticien.id,
        "dateConsultation": disponibilite['dateDebut'],
        "status": "en attente"
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Consultation réservée avec succès')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la réservation')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disponibilités de ${widget.dieteticien.nom}'),
      ),
      body: _disponibilites.isEmpty
          ? Center(child: Text('Aucune disponibilité disponible.'))
          : ListView.builder(
              itemCount: _disponibilites.length,
              itemBuilder: (context, index) {
                final disponibilite = _disponibilites[index];
                DateTime dateDebut = DateTime.parse(disponibilite['dateDebut']);
                DateTime dateFin = DateTime.parse(disponibilite['dateFin']);
                String formattedDateDebut = DateFormat('dd/MM/yyyy HH:mm').format(dateDebut);
                String formattedDateFin = DateFormat('dd/MM/yyyy HH:mm').format(dateFin);

                return ListTile(
                  title: Text('De: $formattedDateDebut à $formattedDateFin'),
                  onTap: () => reserverConsultation(disponibilite),
                );
              },
            ),
    );
  }
}
