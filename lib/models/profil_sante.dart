import 'package:equilibromobile/models/allergie.dart';
import 'package:equilibromobile/models/maladie.dart';
import 'package:equilibromobile/models/objectif_sante.dart';
import 'package:equilibromobile/models/preference_alimentaire.dart';
import 'package:equilibromobile/models/utilisateur.dart';

class ProfilDeSante {
  final int? id;
  final List<Maladie> maladies;
  final List<ObjectifSante> objectifs;
  final List<Allergie> allergies;
  final List<PreferenceAlimentaire> preferencesAlimentaires;
  final Utilisateur utilisateur;

  ProfilDeSante({
    this.id,
    required this.maladies,
    required this.objectifs,
    required this.allergies,
    required this.preferencesAlimentaires,
    required this.utilisateur,
  });

  factory ProfilDeSante.fromJson(Map<String, dynamic> json) {
    var maladiesJson = json['maladies'] as List? ?? [];
    var objectifsJson = json['objectifs'] as List? ?? [];
    var allergiesJson = json['allergies'] as List? ?? [];
    var preferencesJson = json['preferencesAlimentaires'] as List? ?? [];

    return ProfilDeSante(
      id: json['id'],
      maladies: maladiesJson.map((m) => Maladie.fromJson(m)).toList(),
      objectifs: objectifsJson.map((o) => ObjectifSante.fromJson(o)).toList(),
      allergies: allergiesJson.map((a) => Allergie.fromJson(a)).toList(),
      preferencesAlimentaires: preferencesJson.map((p) => PreferenceAlimentaire.fromJson(p)).toList(),
      utilisateur: Utilisateur.fromJson(json['utilisateur']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'maladies': maladies.map((m) => m.toJson()).toList(),
      'objectifs': objectifs.map((o) => o.toJson()).toList(),
      'allergies': allergies.map((a) => a.toJson()).toList(),
      'preferencesAlimentaires': preferencesAlimentaires.map((p) => p.toJson()).toList(),
      'utilisateur': utilisateur.toJson(),
    };
  }
}