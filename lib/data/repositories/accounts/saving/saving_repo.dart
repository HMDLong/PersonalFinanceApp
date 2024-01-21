import 'package:saving_app/data/models/accounts.model.dart';

abstract class SavingRepository {
  Future<List<Saving>> getSavings();
  Future<Saving?> getById(String id);
  Future<void> putSaving(Saving newSaving);
  Future<void> updateSaving(Saving newSaving);
  Future<void> deleteSaving(String id);
}