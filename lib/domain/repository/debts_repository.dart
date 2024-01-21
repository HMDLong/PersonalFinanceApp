import 'package:saving_app/data/models/accounts.model.dart';

abstract class DebtsRepository {
  Future<List<Debt>> getDebts();
  Future<Debt?> getById(String id);
  Future<void> putDebt(Debt newDebt);
  Future<void> updateDebt(String id, Debt updatedDebt);
}