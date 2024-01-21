import 'package:saving_app/data/models/accounts.model.dart';

abstract class BaseSavingRepository {
  Future<List<Saving>> getSavings();
  Future<void> putNewSaving(Saving newSaving);
}