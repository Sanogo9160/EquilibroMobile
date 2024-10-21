import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/dieteticien.dart';
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

  Future<void> _fetchDisponibilites() async {
    final authService = AuthService();
    String? token = await authService.getToken();

    final response = await http.get(
      Uri.parse(
          '${AppConfig.baseUrl}/disponibilites/dieteticien/${widget.dieteticien.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _disponibilites = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des disponibilités')),
      );
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
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _disponibilites.length,
              itemBuilder: (context, index) {
                final disponibilite = _disponibilites[index];
                return ListTile(
                  title: Text(
                      'De: ${disponibilite['dateDebut']} à ${disponibilite['dateFin']}'),
                  onTap: () => reserverConsultation(disponibilite),
                );
              },
            ),
    );
  }
}
