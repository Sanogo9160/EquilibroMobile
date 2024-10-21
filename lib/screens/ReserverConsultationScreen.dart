import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import '../models/dieteticien.dart';
import '../services/auth_service.dart';
import '../config.dart';

class ReserverConsultationScreen extends StatefulWidget {
  final Dieteticien dieteticien;

  ReserverConsultationScreen({required this.dieteticien});

  @override
  _ReserverConsultationScreenState createState() =>
      _ReserverConsultationScreenState();
}

class _ReserverConsultationScreenState
    extends State<ReserverConsultationScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, List<Map<String, dynamic>>> _events = {};  // Disponibilités
  List<Map<String, dynamic>> _selectedEvents = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _fetchDisponibilites();
  }

  // Fonction pour récupérer les disponibilités depuis l'API
  Future<void> _fetchDisponibilites() async {
    final authService = AuthService();
    String? token = await authService.getToken();

    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/disponibilites/dieteticien/${widget.dieteticien.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final disponibilites = json.decode(response.body) as List<dynamic>;

      // Conversion des disponibilités en événements pour le calendrier
      Map<DateTime, List<Map<String, dynamic>>> events = {};
      for (var dispo in disponibilites) {
        DateTime dateDebut = DateTime.parse(dispo['dateDebut']);
        events[dateDebut] = events[dateDebut] ?? [];
        events[dateDebut]!.add(dispo);
      }

      setState(() {
        _events = events;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des disponibilités')),
      );
    }
  }

  // Fonction pour réserver une consultation
  Future<void> reserverConsultation(Map<String, dynamic> disponibilite) async {
    try {
      final authService = AuthService();
      int? utilisateurId = await authService.getUtilisateurId();

      if (utilisateurId == null) return;

      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/consultations/reserver'),
        headers: {
          'Authorization': 'Bearer ${await authService.getToken()}',
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
        throw Exception('Erreur lors de la réservation');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réserver avec ${widget.dieteticien.nom}'),
      ),
      body: Column(
        children: [
          // Calendrier affichant les disponibilités
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.now(),
            lastDay: DateTime(2100),
            calendarFormat: _calendarFormat,
            eventLoader: (day) => _events[day] ?? [],
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedEvents = _events[selectedDay] ?? [];
              });
            },
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: _selectedEvents.isEmpty
                ? Center(child: Text('Aucune disponibilité pour ce jour'))
                : ListView.builder(
                    itemCount: _selectedEvents.length,
                    itemBuilder: (context, index) {
                      final disponibilite = _selectedEvents[index];
                      return ListTile(
                        title: Text(
                          'De: ${disponibilite['dateDebut']} à ${disponibilite['dateFin']}',
                        ),
                        onTap: () => reserverConsultation(disponibilite),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
