import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/features/accounts/models/account.dart';

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
  double? originInterest;
  int? minPayment;
  DateTime? phaselyDuedate;
  
  Installment({
    this.period,
    this.originInterest,
    this.phaselyDuedate,
    this.minPayment,
  });
  
  @override
  Map<String, dynamic> toJson() => 
  {
    "type": type,
    "period": period,
    "interest": originInterest,
    "min": minPayment,
    "duedate": phaselyDuedate!.toIso8601String(),
  };

  Installment.fromJson(Map<String, dynamic> json) {
    period = json["period"] as int;
    minPayment = json["min"] as int;
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