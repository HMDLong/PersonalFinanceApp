import 'package:flutter/material.dart';

class PlanSettingsController extends ChangeNotifier {
  BudgetDist budgetDist;

  PlanSettingsController(BudgetDist budgetDist) :
    budgetDist = budgetDist {
      budgetDist.toString();
    }
}

class BudgetDist {

}