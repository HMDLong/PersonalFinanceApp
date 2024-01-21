import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/local/repository_impl/saving_repo_impl.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/domain/repository/saving_repository.dart';

final savingProvider = AsyncNotifierProvider<SavingsNotifier, List<Saving>>(() {
  return SavingsNotifier(repository: SavingRepositoryLocalImpl());
});

class SavingsNotifier extends AsyncNotifier<List<Saving>> {
  final BaseSavingRepository _repository;
  SavingsNotifier({
    required BaseSavingRepository repository,
  }) : _repository = repository;

  Future<List<Saving>> _fetchSavings() async {
    return _repository.getSavings();
  }

  @override
  FutureOr<List<Saving>> build() {
    return _fetchSavings();
  }

  Future<void> newSaving(Saving newSaving) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.putNewSaving(newSaving);
      return _fetchSavings();
    });
  }
}
