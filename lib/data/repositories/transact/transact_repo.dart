import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/transaction.model.dart';

abstract class TransactRepository {
  List<Transaction> getTransactions();
  List<Transaction> getTransactionsByType(TransactionType type);
  Transaction? getTransactionById(String id);
  void putTransaction(Transaction newTransaction);
  void updateTransaction(Transaction newTransaction);
  void deleteTransaction(String id); 
}
