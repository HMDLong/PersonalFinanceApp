import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/plan_transaction.model.dart';
import 'package:saving_app/utils/randoms.dart';

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