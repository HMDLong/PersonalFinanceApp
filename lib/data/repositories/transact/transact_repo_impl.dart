import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saving_app/constants/constants.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/data/repositories/transact/transact_repo.dart';

class TransactionRepositoryImpl extends TransactRepository {
  late Box<Transaction> transactionBox;

  TransactionRepositoryImpl() {
    transactionBox = Hive.box<Transaction>(transactionBoxName);
  }

  @override
  void deleteTransaction(String id) {
    transactionBox.delete(id);
  }

  @override
  Transaction? getTransactionById(String id) {
    return transactionBox.get(id);
  }

  @override
  List<Transaction> getTransactions() {
    return transactionBox.values.toList();
  }

  @override
  List<Transaction> getTransactionsByType(TransactionType type) {
    throw UnimplementedError();
  }

  @override
  void putTransaction(Transaction newTransaction) {
    transactionBox.put(newTransaction.id, newTransaction);
  }
  
  @override
  void updateTransaction(Transaction newTransaction) {
    transactionBox.put(newTransaction.id, newTransaction);
  }
}

final transactionRepoProvider = Provider((ref) => TransactionRepositoryImpl());
