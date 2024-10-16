import 'package:flutter/material.dart';
import '../models/plan_de_repas.dart';

class PlanificationService extends ChangeNotifier {
  List<PlanDeRepas> planDeRepas = [];

  void ajouterPlanDeRepas(PlanDeRepas planDeRepas) {
    this.planDeRepas.add(planDeRepas);
    notifyListeners();
  }

  void supprimerPlanDeRepas(int index) {
    planDeRepas.removeAt(index);
    notifyListeners();
  }
}
