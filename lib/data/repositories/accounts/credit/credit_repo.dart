import 'package:saving_app/data/models/accounts.model.dart';

abstract class CreditRepository {
  Future<List<Credit>> getCredits();
  Future<Credit?> getById(String id);
  Future<void> putCredit(Credit newCredit);
  Future<void> updateCredit(Credit newCredit);
  Future<void> deleteCredit(String id);
}