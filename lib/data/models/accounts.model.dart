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

class Debit extends Account {
  Debit({required super.id, super.amount, super.title});

  Debit.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "amount": amount,
      "title": title,
    };
  }
}

class Debt extends Account {
  late Payment payment;

  Debt({
    required super.id,
    super.amount, 
    required super.title,
    required this.payment,
  });

  Debt.fronJson(Map<String, dynamic> json) : super.fromJson(json) {
    final paymentData = json["payment"] as Map<String, dynamic>;
    payment = Payment.fromJson(paymentData["type"] as String, paymentData);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "amount": amount,
      "payment": payment.toJson(),
    };
  }

  @override
  String toString() {
    return "Debt{$id/$title/$amount/$payment}";
  }

  Transaction scheduleTransaction() {
    return Transaction(
      id: id!, 
      planTransactTitle: title,
      amount: amount!, 
      categoryId: "",
      targetAccountId: id!,
      transactType: TransactionType.transact,
      timestamp: payment.payDate,
    );
  }
}

class Credit extends Account {
  int? limit;
  Payment? payment;

  Credit({
    super.id,
    super.amount = 0,
    required super.title,
    required this.payment,
    required this.limit,
  });

  @override
  int get usableBalance => limit!.abs() - amount!.abs();

  Credit.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    limit = json['limit'];
    final paymentData = json['payment'] as Map<String, dynamic>;
    payment = Payment.fromJson(paymentData['type'] as String, paymentData);
  }

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "title": title,
    "limit": limit,
    "payment": payment!.toJson(),
  };

  PlanTransaction makePlanTransaction() {
    return PlanTransaction(
      id: getRandomKey(), 
      title: title!, 
      amount: amount!, 
      categoryId: "c12.1",
      targetAccount: id!,
      transactType: TransactionType.transact,
    );
  }
}

enum PaymentType {
  installment,
  infull,
}

sealed class Payment {
  Payment();

  factory Payment.fromJson(String type, Map<String, dynamic> json) =>
    switch(type){
      'installment' => Installment.fromJson(json),
      'infull' => Infull.fromJson(json),
      _ => throw Exception('Invalid payment type'),
    };

  Map<String, dynamic> toJson();
  double getLatePayment(int amount);
  DateTime get payDate;
  int get minimumPayment;
}

class Installment extends Payment {
  static const String type = 'installment';
  int? period;
  // int? phase;
  double? originInterest;
  int? minPayment;
  DateTime? phaselyDuedate;
  
  Installment({
    this.period,
    // this.phase,
    this.originInterest,
    this.phaselyDuedate,
    this.minPayment,
  });
  
  @override
  Map<String, dynamic> toJson() => 
  {
    "type": type,
    "period": period,
    // "phase": phase,
    "interest": originInterest,
    "min": minPayment,
    "duedate": phaselyDuedate!.toIso8601String(),
  };

  Installment.fromJson(Map<String, dynamic> json) {
    period = json["period"] as int;
    minPayment = json["min"] as int;
    // phase = json["phase"] as int;
    originInterest = json["interest"] as double;
    phaselyDuedate = DateTime.parse(json["duedate"] as String);
  }

  @override
  DateTime get payDate => phaselyDuedate!;

  @override
  double getLatePayment(int amount) => amount * originInterest!;

  @override
  String toString() {
    return "Installment{$type, $period, phase, $originInterest, $phaselyDuedate}";
  }
  
  @override
  int get minimumPayment => minPayment!;
}

class Infull extends Payment {
  static const String type = 'infull';
  DateTime? duedate;
  double? lateInterest;
  int? minPayment;

  Infull({
    this.duedate,
    this.lateInterest,
    this.minPayment,
  });

  @override
  Map<String, dynamic> toJson() =>
  {
    "type": type,
    "interest": lateInterest,
    "min": minPayment,
    "duedate": duedate!.toIso8601String(),
  };

  Infull.fromJson(Map<String, dynamic> json) {
    duedate = DateTime.parse(json["duedate"] as String);
    lateInterest = json["interest"] as double;
    minPayment = json["min"] as int;
  }
  
  @override
  double getLatePayment(int amount) => amount * lateInterest!;

  @override
  String toString() {
    return "Infull{$type, $duedate, $lateInterest}";
  }
  
  @override
  DateTime get payDate => duedate!;
  
  @override
  int get minimumPayment => minPayment!;
}

