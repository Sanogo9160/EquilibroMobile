
import 'package:equilibromobile/models/dieteticien.dart';
import 'package:equilibromobile/models/utilisateur_simple.dart';

class Consultation {
  final int id;
  final DateTime dateConsultation;
  final String commentaires;
  final Dieteticien dieteticien; // Supposons que vous ayez un modèle Dieteticien
  final UtilisateurSimple utilisateur; // Supposons que vous ayez un modèle UtilisateurSimple

  Consultation({
    required this.id,
    required this.dateConsultation,
    required this.commentaires,
    required this.dieteticien,
    required this.utilisateur,
  });

  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      id: json['id'],
      dateConsultation: DateTime.parse(json['dateConsultation']),
      commentaires: json['commentaires'],
      dieteticien: Dieteticien.fromJson(json['dieteticien']),
      utilisateur: UtilisateurSimple.fromJson(json['utilisateur']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateConsultation': dateConsultation.toIso8601String(),
      'commentaires': commentaires,
      'dieteticien': dieteticien.toJson(),
      'utilisateur': utilisateur.toJson(),
    };
  }
}
