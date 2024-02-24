import 'package:saving_app/features/accounts/models/account.dart';

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