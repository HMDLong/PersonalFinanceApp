import 'package:saving_app/data/models/accounts.model.dart';

sealed class DebtStrategy {
  String get title;
  StrategyType get type;

  factory DebtStrategy.fromJson(Map<String, dynamic> jsonData) {
    if(jsonData["type"] == StrategyType.avalanche.toString()) {
      return AvalanceStrategy();
    }
    if(jsonData["type"] == StrategyType.snowball.toString()) {
      return SnowballStrategy();
    }
    throw Exception("Not found type ${jsonData['type']}");
  }

  DebtStrategy();

  Map<String, dynamic> toJson() => {
    "type": type.toString(),
  };

  /// calculate schedule and payment for the debts
  List<Debt> adapt(List<Debt> debtsToAdapt, {bool updateSchedule = true, bool updatePayment = true,});
  bool validate();
}

class AvalanceStrategy extends DebtStrategy {
  @override
  StrategyType get type => StrategyType.avalanche;

  @override
  String get title => "Tuyết lở";
  
  @override
  List<Debt> adapt(List<Debt> debtsToAdapt, {bool updateSchedule = true, bool updatePayment = true}) {
    return debtsToAdapt;
  }
  
  @override
  bool validate() {
    return true;
  }

  @override
  bool operator ==(other) {
    return other is AvalanceStrategy;
  }
  
  @override
  int get hashCode => type.toString().hashCode;
}

class SnowballStrategy extends DebtStrategy {
  @override
  StrategyType get type => StrategyType.snowball;

  @override
  String get title => "Lăn cầu tuyết";
  
  @override
  List<Debt> adapt(List<Debt> debtsToAdapt, {bool updateSchedule = true, bool updatePayment = true}) {
    return debtsToAdapt;
  }
  
  @override
  bool validate() {
    return true;
  }
}

enum DebtStatus {
  safe,
  danger 
}

enum StrategyType {
  avalanche,
  snowball,
}