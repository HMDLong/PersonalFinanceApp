class Account {
  String? id;
  int? amount;

  Account({
    required this.id,
    this.amount = 0,
  });

  Account.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    amount = json['amount'];
}

class Credit extends Account {
  String? title;
  int? limit;
  Payment? payment;

  Credit({
    super.id,
    super.amount = 0,
    required this.title,
    required this.payment,
    required this.limit,
  });

  Credit.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    title = json['title'];
    limit = json['limit'];
    final paymentData = json['payment'] as Map<String, dynamic>;
    payment = Payment.fromJson(paymentData['type'] as String, json);
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "title": title,
    "limit": limit,
    "payment": payment!.toJson(),
  };
}

class Saving extends Account {
  double? interest;
  int? period;
  String? title;
  Goal? goal;

  Saving({
    required super.id, 
    super.amount = 0,
    this.interest = 0.0,
    this.period,
    this.title,
    this.goal,
  });

  Saving.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    interest = json["interest"] as double;
    amount = json["amount"] as int;
    period = json["period"] as int;
    title = json["title"] as String;
    if(json.containsKey("goal")){
      goal = Goal.fromJson(json["goal"] as Map<String, dynamic>);
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["amount"] = amount;
    json["period"] = period;
    json["interest"] = interest;
    if(title != null) {
      json["title"] = title;
    }
    // if(goal != null) {
    //   json["goal"] = goal?.toJson();
    // }
    return json;
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
}

class Debit extends Account {
  Debit({required super.id, super.amount});

  Debit.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "amount": amount,
    };
  }
}

class Debt extends Account {
  late String title;
  late Payment payment;

  Debt({
    required super.id,
    super.amount, 
    required this.title,
    required this.payment,
  });

  Debt.fronJson(Map<String, dynamic> json) : super.fromJson(json) {
    title = json["title"] as String;
    final paymentData = json["payment"] as Map<String, dynamic>;
    payment = Payment.fromJson(paymentData["type"] as String, paymentData);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "amount": amount,
      "payment": payment.toJson(),
    };
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
}

class Installment extends Payment {
  static const String type = 'installment';
  int? period;
  int? phase;
  double? originInterest;
  DateTime? phaselyDuedate;
  
  Installment({
    this.period,
    this.phase,
    this.originInterest,
    this.phaselyDuedate,
  });
  
  @override
  Map<String, dynamic> toJson() => 
  {
    "type": type,
    "period": period,
    "phase": phase,
    "interest": originInterest,
    "duedate": phaselyDuedate!.toIso8601String(),
  };

  Installment.fromJson(Map<String, dynamic> json) {
    period = json["period"] as int;
    phase = json["phase"] as int;
    originInterest = json["originInterest"] as double;
    phaselyDuedate = DateTime.parse(json["period"] as String);
  }

  @override
  double getLatePayment(int amount) => amount * originInterest!;
}

class Infull extends Payment {
  static const String type = 'infull';
  DateTime? duedate;
  double? lateInterest;

  Infull({
    this.duedate,
    this.lateInterest,
  });

  @override
  Map<String, dynamic> toJson() =>
  {
    "type": type,
    "interest": lateInterest,
    "duedate": duedate!.toIso8601String(),
  };

  Infull.fromJson(Map<String, dynamic> json) {
    lateInterest = json["interest"] as double;
    duedate = DateTime.parse(json["duedate"] as String);
  }
  
  @override
  double getLatePayment(int amount) => amount * lateInterest!;
}

