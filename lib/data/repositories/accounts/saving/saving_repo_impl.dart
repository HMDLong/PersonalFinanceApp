import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/data/repositories/accounts/saving/saving_repo.dart';

final savingRepoProvider = Provider((ref) => SavingRepositoryImpl());

class SavingRepositoryImpl extends SavingRepository {
  @override
  Future<void> deleteSaving(String id) {
    // TODO: implement deleteSaving
    throw UnimplementedError();
  }

  @override
  Future<Saving?> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<Saving>> getSavings() {
    // TODO: implement getSavings
    throw UnimplementedError();
  }

  @override
  Future<void> putSaving(Saving newSaving) {
    // TODO: implement putSaving
    throw UnimplementedError();
  }

  @override
  Future<void> updateSaving(Saving newSaving) {
    // TODO: implement updateSaving
    throw UnimplementedError();
  }
}