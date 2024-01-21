import 'package:saving_app/data/models/accounts.model.dart';

abstract class DebitRepository {
  Future<List<Debit>> getDebits();
  Future<Debit?> getById(String id);
  Future<void> putDebit(Debit newDebit);
  Future<void> updateDebit(Debit newDebit);
  Future<void> deleteDebit(String id);
}