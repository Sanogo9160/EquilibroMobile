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

    // Envoie de notification
    await envoyerNotification(
          dieteticienId, "Nouvelle réservation de consultation reçue.");
   
  } else {
    // Ajoute un log pour connaître l'erreur exacte
    print('Erreur de réservation : ${response.statusCode}, Body: ${response.body}');
    throw Exception('Erreur lors de la réservation');
  }
}

  // Confirmer une consultation et envoie de notification
  Future<void> confirmerConsultation(int consultationId,  int utilisateurId) async {
    String? token = await _authService.getToken();

    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/consultations/confirmer/$consultationId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

   if (response.statusCode == 200) {
      // After confirmation, send notification to the user
      await envoyerNotification(
          utilisateurId, "Votre réservation de consultation a été confirmée.");
    } else {
      throw Exception('Erreur lors de la confirmation');
    }
  }

  // Fonction pour envoyer une notification à un utilisateur ou diététicien
  Future<void> envoyerNotification(int utilisateurId, String message) async {
    String? token = await _authService.getToken();

    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/notifications'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "utilisateurId": utilisateurId,
        "message": message,
      }),
    );

    if (response.statusCode == 200) {
      print("Notification envoyée avec succès");
    } else {
      print('Erreur lors de l\'envoi de la notification : ${response.statusCode}');
      throw Exception('Erreur lors de l\'envoi de la notification');
    }
  }


}
