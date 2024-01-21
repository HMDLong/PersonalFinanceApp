import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/models/plan/debt_strat.dart';
import 'package:saving_app/data/models/plan/income_dist.dart';
import 'package:saving_app/data/models/plan/plan.dart';
import 'package:saving_app/data/repositories/plan_settings/plan_settings_repo.dart';
import 'package:saving_app/data/repositories/plan_settings/plan_settings_repo_impl.dart';

class PlanSettingNotifier extends ChangeNotifier {
  final PlanSettingRepository _repo;

  PlanSettingNotifier({
    required PlanSettingRepository repo
  }) : _repo = repo;

  Future<PlanSetting> getPlanSettings() async {
    return await _repo.getPlanSettings();
  }

  Future<void> setDebtStrategy(DebtStrategy newStrategy) async {
    final currentSetting = await getPlanSettings();
    await _repo.setPlanSetting(currentSetting..strategy = newStrategy);
    notifyListeners();
  }

  Future<void> setIncomeDist(PlanDistribution dist) async {
    final currentSetting = await getPlanSettings();
    await _repo.setPlanSetting(currentSetting..incomeDist = dist);
    notifyListeners();
  }
}

final planSettingProvider = ChangeNotifierProvider((ref) {
  return PlanSettingNotifier(repo: ref.watch(planSettingRepoProvider));
});

final currentIncomeDistProvider = FutureProvider((ref) async {
  final setting = await ref.watch(planSettingProvider).getPlanSettings();
  return setting.incomeDist;
});

final currentDebtStrategyProvider = FutureProvider((ref) async {
  return (await ref.watch(planSettingProvider).getPlanSettings()).strategy;
});
