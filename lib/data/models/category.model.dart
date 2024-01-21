import 'package:flutter/material.dart';
import 'package:saving_app/utils/json.dart';

class CustomCategory {
  String? id;
  String? name;
  TransactionType? type;
  IconData? icon;
  Budget? budget;

  CustomCategory({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    this.budget,
  });

  CustomCategory.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    type = jsonToTransactType(json["type"]);
    icon = jsonToIcon(json["icon"]);
    if(json.containsKey("budget")) {
      budget = Budget.fromJson(json["budget"] as Map<String, dynamic>);
    } else {
      budget = Budget(amount: 0, categoryId: id);
    }
  }

  @override
  String toString() {
    return "Category{$id/$budget}";
  }
}

class CategoryGroup extends CustomCategory {
  double budgetPercentage;
  List<TransactCategory> subCategories;

  CategoryGroup({
    required super.id,
    required super.name, 
    required super.type, 
    required super.icon,
    super.budget,
    this.budgetPercentage = 0.0,
    this.subCategories = const [],
  });

  void addCategory(TransactCategory category) {
    subCategories.add(category);
  }

  @override
  String toString() {
    return "Group{$id/$budget/$subCategories}";
  }
}

class TransactCategory extends CustomCategory{
  TransactCategory({
    required super.id,
    required super.name, 
    required super.type, 
    required super.icon,
    super.budget,
  });

  @override
  bool operator ==(Object other) {
    return (other is TransactCategory) && other.name == name;
  }

  TransactCategory.fromJson(Map<String, dynamic> jsonData) : super.fromJson(jsonData) {
    if(jsonData.containsKey("budget")){
      budget = Budget.fromJson(jsonData["budget"] as Map<String, dynamic>);
    }
  }
    
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = id;
    json['name'] = name;
    json['type'] = transactTypeToJson(type!);
    json['icon'] = iconToJson(icon!);
    return json;
  }
}

enum TransactionType { 
  expense,
  income,
  transact,
}

enum BudgetPeriod {
  weekly,
  monthly,
  yearly
}

BudgetPeriod deserialize(String jsonString) {
  try {
    return BudgetPeriod.values.where((element) => element.toString() == jsonString).first;
  } catch(e) {
    rethrow;
  }
}

class Budget {
  String? categoryId;
  int? amount;
  BudgetPeriod? period;

  Budget({
    required this.amount,
    required this.categoryId,
    this.period = BudgetPeriod.monthly,
  });

  Budget.fromJson(Map<String, dynamic> json) {
    categoryId = json["category_id"];
    amount = json["amount"];
    period = deserialize(json["period"]);
  }

  Map<String, dynamic> toJson() =>
    {
      "category_id": categoryId,
      "amount": amount,
      "period": period.toString(),
    };

  int getMonthlyTotal() {
    return switch(period) {
      BudgetPeriod.monthly => amount!,
      BudgetPeriod.weekly => amount! * 4,
      BudgetPeriod.yearly => amount! ~/ 12,
      null => throw Exception("Invalid budget"),
    };
  }

  @override
  String toString() {
    return "Budget{$categoryId/$amount/$period}";
  }
}