import 'package:equilibromobile/services/consultation-service.dart';
import 'package:flutter/material.dart';
import 'package:equilibromobile/services/auth_service.dart';
import 'package:equilibromobile/models/utilisateur.dart';

class ConfirmationConsultationScreen extends StatelessWidget {
  final int consultationId;
  final ConsultationService _consultationService = ConsultationService();

  ConfirmationConsultationScreen({required this.consultationId});

  Future<void> confirmerConsultation(BuildContext context) async {
    try {
      final authService = AuthService();
      Utilisateur? utilisateur = await authService.getCurrentUser();

      if (utilisateur == null || utilisateur.id == null) {
        throw Exception('Utilisateur non trouvé');
      }

      // Now you can pass the `utilisateur.id!` to the `confirmerConsultation` function
      await ConsultationService().confirmerConsultation(consultationId, utilisateur.id!);

      await _envoyerNotification(context); // Envoi de la notification

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Consultation confirmée avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la confirmation')),
      );
    }
  }

  Future<void> _envoyerNotification(BuildContext context) async {
    try {
      final authService = AuthService();
      Utilisateur? utilisateur = await authService.getCurrentUser();

      if (utilisateur == null || utilisateur.id == null) {
        throw Exception('Utilisateur non trouvé');
      }

      // Envoi de la notification
      await _consultationService.envoyerNotification(
        utilisateur.id!,
        'Votre réservation de consultation a été confirmée.',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'envoi de la notification')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmer la consultation'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => confirmerConsultation(context),
          child: Text('Confirmer'),
        ),
      ),
    );
  }
}
