import 'dart:convert';
import 'package:equilibromobile/config.dart';
import 'package:equilibromobile/models/dieteticien.dart';
import 'package:equilibromobile/screens/ReserverConsultationScreen.dart';
import 'package:equilibromobile/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class DieteticienListScreen extends StatefulWidget {
  @override
  _DieteticienListScreenState createState() => _DieteticienListScreenState();
}

class _DieteticienListScreenState extends State<DieteticienListScreen> {
  List<Dieteticien> _dieteticiens = [];

  @override
  void initState() {
    super.initState();
    _fetchDieteticiens();
  }

  Future<void> _fetchDieteticiens() async {
    final authService = AuthService();
    String? token = await authService.getToken(); 

    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/dieteticiens/liste'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _dieteticiens = data.map((json) => Dieteticien.fromJson(json)).toList();
      });
    } else {
      throw Exception('Erreur lors de la récupération des diététiciens');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choisir un diététicien'),
      ),
      body: _dieteticiens.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _dieteticiens.length,
              itemBuilder: (context, index) {
                final dieteticien = _dieteticiens[index];
                return ListTile(
                  title: Text(dieteticien.nom),
                  subtitle: Text(dieteticien.specialite ?? 'Spécialité non renseignée'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReserverConsultationScreen(
                          dieteticien: dieteticien,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
