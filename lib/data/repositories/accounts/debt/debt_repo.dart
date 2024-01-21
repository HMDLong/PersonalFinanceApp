import 'package:saving_app/data/models/accounts.model.dart';

abstract class DebtRepository {
  Future<List<Debt>> getDebts();
  Future<Debt?> getDebtById(String id);
  Future<void> putDebt(Debt newDebt);
  Future<void> updateDebt(Debt newDebt);
  Future<void> deleteDebt(String id);
}