import 'package:equilibromobile/services/consultation-service.dart';
import 'package:flutter/material.dart';


class ConfirmationConsultationScreen extends StatelessWidget {
  final int consultationId;
  final ConsultationService _consultationService = ConsultationService();

  ConfirmationConsultationScreen({required this.consultationId});

  Future<void> confirmerConsultation(BuildContext context) async {
    try {
      await _consultationService.confirmerConsultation(consultationId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Consultation confirmée avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la confirmation')),
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
