import 'package:hive/hive.dart';

part 'transaction.model.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  DateTime timestamp;
  @HiveField(2)
  String categoryId;
  @HiveField(3)
  int amount;
  @HiveField(4)
  String? description;
  @HiveField(5)
  String? transactAccountId;
  @HiveField(6)
  String? targetAccount;


  Transaction({
    required this.id,
    required this.timestamp,
    required this.amount,
    required this.categoryId,
    required this.transactAccountId,
    this.targetAccount,
    this.description,
  });
}