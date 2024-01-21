import 'package:hive/hive.dart';
import 'package:saving_app/constants/constants.dart';
import 'package:saving_app/data/local/local_repository.dart';
import 'package:saving_app/data/models/transaction.model.dart';

class TransactionRepository extends BaseLocalRepository<Transaction> {
  late final Box<Transaction> transactionBox;
  
  TransactionRepository(){
    transactionBox = Hive.box<Transaction>(transactionBoxName);
  }

  @override
  void deleteAll() {
    // TODO: implement deleteAll
  }

  @override
  void deleteAt(id) {
    // TODO: implement deleteAt
  }

  @override
  List<Transaction> getAll() {
    return transactionBox.values.toList();
  }

  @override
  Transaction? getAt(id) {
    // TODO: implement getAt
    throw UnimplementedError();
  }

  @override
  void put(Transaction value) {
    transactionBox.put(value.id, value);
    notifyListeners();
  }

  @override
  void putAll(List<Transaction> values) {
    // TODO: implement putAll
  }

  @override
  void updateAt(id, Transaction newT) {
    // TODO: implement updateAt
  }
}