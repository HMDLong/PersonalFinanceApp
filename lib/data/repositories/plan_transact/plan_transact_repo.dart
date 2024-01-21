import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/plan_transaction.model.dart';

abstract class PlanTransactionRepository {
  Future<List<PlanTransaction>> getPlanTransacts();
  Future<PlanTransaction?> getPlanTransactById(String id);
  Future<List<PlanTransaction>> getPlanTransactsByType(TransactionType type);
  Future<void> putPlanTransact(PlanTransaction newPlanTransact);
  Future<void> updatePlanTransact(PlanTransaction updatedTransact);
}