import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/local/model_repos/budget/budget_json_repo.dart';

class BudgetManager {
  final BudgetJsonRepository _budgetRepository;

  BudgetManager({
    required BudgetJsonRepository repository,
  }) : _budgetRepository = repository;
  

  void tryEvaluateAndAdd(Budget newBudget) {
    evaluateIncome();
    _budgetRepository.put(newBudget);
  }

  void evaluateIncome(){
    
  }

  List<Budget> getAll() {
    return _budgetRepository.getAll();
  }

  bool hasBudget(String categoryId) {
    return _budgetRepository.getAt(categoryId) != null;
  }
}

// enum ResultCode {
//   accepted,
//   rejected,
// }

// class Result {
//   ResultCode res;
//   List<String> messages;

//   Result({
//     required this.res,
//     this.messages = const <String>[],
//   });
// }