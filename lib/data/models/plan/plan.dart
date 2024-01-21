import 'dart:convert';

import 'package:saving_app/data/models/plan/debt_strat.dart';
import 'package:saving_app/data/models/plan/income_dist.dart';

class PlanSetting {
  DebtStrategy? strategy;
  PlanDistribution? incomeDist;

  PlanSetting();

  PlanSetting.fromJsonString(String jsonString) {
    final data = json.decode(jsonString) as Map<String, dynamic>;
    strategy = DebtStrategy.fromJson(data["strategy"]);
    incomeDist = PlanDistribution.fromJson(data["income_dist"]);
  }

  String toJsonString() {
    return json.encode(_toMap());
  }

  Map<String, dynamic> _toMap() => {
    "strategy": strategy!.toJson(),
    "income_dist": incomeDist!.toJson(),
  };

  @override
  String toString() {
    return "PlanSetting{$strategy}";
  }

  // logic here
}
