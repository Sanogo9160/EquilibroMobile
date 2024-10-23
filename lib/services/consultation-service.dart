import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'auth_service.dart';

class ConsultationService {
  final AuthService _authService = AuthService();


   // Réserver une consultation
Future<void> reserverConsultation(
    int utilisateurId, int dieteticienId, DateTime date, String motif) async {
  String? token = await _authService.getToken();

  final response = await http.post(
    Uri.parse('${AppConfig.baseUrl}/consultations/reserver'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "utilisateurId": utilisateurId,
      "dieteticienId": dieteticienId,
      "dateConsultation": date.toIso8601String(),
      "motif": motif,
    }),
  );

  if (response.statusCode == 200) {
    print("Consultation réservée avec succès");
  } else {
    // Ajoute un log pour connaître l'erreur exacte
    print('Erreur de réservation : ${response.statusCode}, Body: ${response.body}');
    throw Exception('Erreur lors de la réservation');
  }
}

  // Confirmer une consultation
  Future<void> confirmerConsultation(int consultationId) async {
    String? token = await _authService.getToken();

    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/consultations/confirmer/$consultationId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la confirmation');
    }

  }
}
