import 'package:saving_app/features/accounts/models/account.dart';

class Cash extends Account {
  Cash({required super.id});

  Cash.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  AccountType get accountType => AccountType.cash;
}