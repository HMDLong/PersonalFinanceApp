import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/plan_transaction.model.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/utils/randoms.dart';

class Account {
  String? id;
  int? amount;
  String? title;

  Account({
    required this.id,
    this.amount = 0,
    this.title,
  });

  Account.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    amount = json['amount'],
    title = json['title'];

  Map<String, dynamic> toJson() =>
  {
    "id": id,
    "amount": amount,
    "title": title,
  };

  int get usableBalance => amount!;
}

class Saving extends Account {
  double? interest;
  int? period;
  Goal? goal;

  Saving({
    required super.id, 
    super.amount = 0,
    super.title,
    this.interest = 0.0,
    this.period,
    this.goal,
  });

  Saving.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    interest = json["interest"] as double;
    amount = json["amount"] as int;
    period = json["period"] as int;
    if(json.containsKey("goal")){
      goal = Goal.fromJson(json["goal"] as Map<String, dynamic>);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["amount"] = amount;
    json["period"] = period;
    json["interest"] = interest;
    if(title != null) {
      json["title"] = title;
    }
    if(goal != null) {
      json["goal"] = goal?.toJson();
    }
    return json;
  }

  @override
  String toString() {
    return "Saving{$id/$title/$amount/$period/$interest/$goal}";
  }
}

class Goal {
  int? targetAmount;
  DateTime? deadline;
  String? title;

  Goal({
    required this.targetAmount,
    this.deadline,
    this.title,
  });

  Goal.fromJson(Map<String, dynamic> json) {
    targetAmount = json["target_amount"] as int;
    if(json.containsKey("deadline")){
      deadline = DateTime.parse(json["deadline"]);
    }
    if(json.containsKey("title")) {
      title = json["title"] as String;
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["target_amount"] = targetAmount;
    if(deadline != null) {
      json["deadline"] = deadline?.toIso8601String();
    }
    if(title != null) {
      json["title"] = title;
    }
    return json;
  }

  @override
  String toString() {
    return "Goal{$title/$targetAmount/$deadline}";
  }
}




