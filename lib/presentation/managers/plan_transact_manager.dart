import 'package:saving_app/data/models/plan_transaction.model.dart';
import 'package:saving_app/data/local/model_repos/plan_transact/plan_transact_repo.dart';

class PlanTransactionController {
  final PlanTransactJsonRepository _repository;

  PlanTransactionController({
    required PlanTransactJsonRepository repository,
  }) : _repository = repository;

  void putNewPlanTransaction(PlanTransaction newPlanTransaction) {
    _repository.put(newPlanTransaction);
  }

  void editPlanTransaction(PlanTransaction edittedPlanTransaction) {
    _repository.updateAt(edittedPlanTransaction.id, edittedPlanTransaction);
  }

  void removePlanTransaction(String planId) {
    _repository.deleteAt(planId);
  }

  List<PlanTransaction> getAll() {
    return _repository.getAll();
  }

  // List<PlanTransaction> getByType() {
  //   final all = _repository.getAll();

  // }
}