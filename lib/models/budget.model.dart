enum BudgetPeriod {
  weekly,
  monthly,
}

BudgetPeriod deserialize(String jsonString) {
  try {
    return BudgetPeriod.values.where((element) => element.toString() == jsonString).first;
  } catch(e) {
    rethrow;
  }
}

abstract class JsonSerializable {
  Map<String, dynamic> toJson();
  JsonSerializable fromJson(Map<String, dynamic> json);
}

class Budget {
  String? id;
  String? categoryId;
  int? amount;
  BudgetPeriod? period;

  Budget({
    required this.id,
    required this.amount,
    required this.categoryId,
    this.period = BudgetPeriod.monthly,
  });

  Budget.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    categoryId = json["category_id"];
    amount = json["amount"];
    period = deserialize(json["period"]);
  }

  Map<String, dynamic> toJson() =>
    {
      "id": id,
      "category_id": categoryId,
      "amount": amount,
      "period": period.toString(),
    };
}