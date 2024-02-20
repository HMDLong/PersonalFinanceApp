import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/models/plan/debt_strat.dart';
import 'package:saving_app/data/models/plan/income_dist.dart';
import 'package:saving_app/data/models/plan/plan.dart';
import 'package:saving_app/data/repositories/plan_settings/plan_settings_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

final planSettingRepoProvider = Provider((ref) => PlanSettingRepositoryImpl());

class PlanSettingRepositoryImpl extends PlanSettingRepository {
  final dataKey = "plan_setting";

  @override
  Future<PlanSetting> getPlanSettings() async {
    final sharedRef = await SharedPreferences.getInstance();
    final strData = sharedRef.getString(dataKey);
    if(strData != null) {
      return PlanSetting.fromJsonString(strData);
    }
    final newPlanSetting = PlanSetting();
    newPlanSetting.strategy = SnowballStrategy();
    newPlanSetting.incomeDist = Distribution532();
    await setPlanSetting(newPlanSetting);
    return newPlanSetting;
  }

  @override
  Future<void> setPlanSetting(PlanSetting newPlanSetting) async {
    final sharedRef = await SharedPreferences.getInstance();
    await sharedRef.setString(dataKey, newPlanSetting.toJsonString());
  }
}
