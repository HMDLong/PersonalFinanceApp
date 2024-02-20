import 'package:hive/hive.dart';
import 'package:saving_app/data/models/category.model.dart';

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
  String? targetAccountId;
  @HiveField(7)
  String? planTransactId;
  @HiveField(8)
  String? planTransactTitle;
  @HiveField(9)
  TransactionType transactType;
  @HiveField(10)
  bool paid;

  Transaction({
    required this.id,
    required this.timestamp,
    required this.amount,
    required this.categoryId,
    required this.transactType,
    this.paid = true,
    this.transactAccountId,
    this.targetAccountId,
    this.description,
    this.planTransactId,
    this.planTransactTitle,
  });
}