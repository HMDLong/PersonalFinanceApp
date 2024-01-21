import 'package:saving_app/data/models/plan/plan.dart';

abstract class PlanSettingRepository {
  Future<PlanSetting> getPlanSettings();
  Future<void> setPlanSetting(PlanSetting newPlanSetting);
}