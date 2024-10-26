import 'dart:convert';
import 'package:equilibromobile/models/utilisateur.dart';
import 'package:equilibromobile/services/consultation-service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Importer le package intl
import '../config.dart';
import '../models/dieteticien.dart';
import '../services/auth_service.dart';

class ReserverConsultationScreen extends StatefulWidget {
  final Dieteticien dieteticien;

  ReserverConsultationScreen({required this.dieteticien});

  @override
  _ReserverConsultationScreenState createState() => _ReserverConsultationScreenState();
}

class _ReserverConsultationScreenState extends State<ReserverConsultationScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, List<Map<String, dynamic>>> _events = {};
  List<Map<String, dynamic>> _selectedEvents = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<String, dynamic>? _selectedDisponibilite;
  String? _selectedTimeDebut; // Heure de début
  String? _selectedTimeFin;   // Heure de fin
  final TextEditingController _motifController = TextEditingController(); // Motif

  @override
  void initState() {
    super.initState();
    _fetchDisponibilites();
  }

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
      Map<DateTime, List<Map<String, dynamic>>> events = {};

      for (var dispo in disponibilites) {
        DateTime dateDebut = DateTime.parse(dispo['dateDebut']);
        DateTime dateFin = DateTime.parse(dispo['dateFin']);

        DateTime dateDebutNormalisee = DateTime(dateDebut.year, dateDebut.month, dateDebut.day);
        DateTime dateFinNormalisee = DateTime(dateFin.year, dateFin.month, dateFin.day);

        for (DateTime date = dateDebutNormalisee; date.isBefore(dateFinNormalisee.add(Duration(days: 1))); date = date.add(Duration(days: 1))) {
          if (events[date] == null) {
            events[date] = [];
          }

          events[date]!.add({
            'dateDebut': dispo['dateDebut'],
            'dateFin': dispo['dateFin'],
          });
        }
      }

      if (mounted) {
        setState(() {
          _events = events;
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement des disponibilités')),
        );
      }
    }
  }

  Future<void> reserverConsultation() async {
    if (_selectedDisponibilite == null) {
      print('Aucun créneau sélectionné');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez sélectionner un créneau disponible.')),
      );
      return;
    }
    if (_selectedTimeDebut == null || _selectedTimeFin == null) {
      print('Heure de début ou de fin non sélectionnée');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez sélectionner une heure de début et une heure de fin.')),
      );
      return;
    }
    if (_motifController.text.isEmpty) {
      print('Motif vide');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer un motif de consultation.')),
      );
      return;
    }

    if (int.parse(_selectedTimeDebut!.replaceAll(':', '')) >= int.parse(_selectedTimeFin!.replaceAll(':', ''))) {
      print('Heure de début >= Heure de fin');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('L\'heure de fin doit être après l\'heure de début.')),
      );
      return;
    }

    try {
      final authService = AuthService();
      Utilisateur? utilisateur = await authService.getCurrentUser();

      if (utilisateur == null || utilisateur.id == null) {
        print('Utilisateur non trouvé ou ID null');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : utilisateur non trouvé.')),
        );
        return;
      }

      print("Appel à l'API de réservation");
      await ConsultationService().reserverConsultation(
        utilisateur.id!,
        widget.dieteticien.id!,
        DateTime.parse(_selectedDisponibilite!['dateDebut']),
        _motifController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Consultation réservée avec succès')),
        );
      }
    } catch (e) {
      print('Erreur lors de la réservation: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réserver avec ${widget.dieteticien.nom}'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TableCalendar(
                locale: 'fr_FR', // Configurer le calendrier en français
                focusedDay: _focusedDay,
                firstDay: DateTime.now(),
                lastDay: DateTime(2100),
                calendarFormat: _calendarFormat,
                eventLoader: (day) {
                  DateTime dateNormalisee = DateTime(day.year, day.month, day.day);
                  return _events[dateNormalisee] ?? [];
                },
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  DateTime dateNormalisee = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

                  setState(() {
                    _selectedDay = dateNormalisee;
                    _focusedDay = focusedDay;
                    _selectedEvents = _events[dateNormalisee] ?? [];
                  });

                  if (_selectedEvents.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Aucune disponibilité pour ce jour')),
                    );
                  } else {
                    setState(() {
                      _selectedDisponibilite = _selectedEvents.first;
                    });
                  }
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  outsideDaysVisible: false,
                ),
              ),
              const SizedBox(height: 16.0),
              if (_selectedEvents.isNotEmpty) ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _selectedEvents.length,
                  itemBuilder: (context, index) {
                    final disponibilite = _selectedEvents[index];
                    // Formatter les dates en anglais
                    String dateDebut = DateFormat('EEEE, d MMMM yyyy', 'en_US').format(DateTime.parse(disponibilite['dateDebut']));
                    String dateFin = DateFormat('EEEE, d MMMM yyyy', 'en_US').format(DateTime.parse(disponibilite['dateFin']));

                    return ListTile(
                      title: Text(
                        'De: $dateDebut à $dateFin',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedDisponibilite = disponibilite;
                        });
                      },
                      selected: _selectedDisponibilite == disponibilite,
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                // Dropdown pour l'heure de début 
                DropdownButtonFormField<String>(
                  value: _selectedTimeDebut,
                  hint: Text('Sélectionner l\'heure de début'),
                  items: [
                    '09:00',
                    '10:00',
                    '11:00',
                    '14:00',
                    '15:00',
                    '16:00',
                  ].map((time) {
                    return DropdownMenuItem(
                      value: time,
                      child: Text(time),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTimeDebut = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Heure de début',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                // Dropdown pour l'heure de fin
                DropdownButtonFormField<String>(
                  value: _selectedTimeFin,
                  hint: Text('Sélectionner l\'heure de fin'),
                  items: [
                    '10:00',
                    '11:00',
                    '12:00',
                    '15:00',
                    '16:00',
                    '17:00',
                  ].map((time) {
                    return DropdownMenuItem(
                      value: time,
                      child: Text(time),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTimeFin = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Heure de fin',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                // Champ de texte pour le motif
                TextField(
                  controller: _motifController,
                  decoration: InputDecoration(
                    labelText: 'Motif de consultation',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                // Bouton Réserver élargi
                Container(
                  width: double.infinity, // Prend toute la largeur disponible
                  child: ElevatedButton(
                    onPressed: reserverConsultation,
                    child: Text(
                      'Réserver',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}