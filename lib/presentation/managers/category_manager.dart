import 'package:flutter/material.dart';
import 'package:saving_app/data/local/model_repos/budget/budget_json_repo.dart';
import 'package:saving_app/data/local/model_repos/records/category_repository.dart';
import 'package:saving_app/data/models/category.model.dart';

class CategoryController extends ChangeNotifier {
  final CategoryRepository repository;
  final BudgetJsonRepository budgetJsonRepository;

  CategoryController({required this.repository, required this.budgetJsonRepository});

  List<CategoryGroup> getCategoriesWithBudget() {
    final groups = repository.getAllCategories();
    final res = <CategoryGroup>[];
    for(var group in groups) {
      final budget = budgetJsonRepository.getAt(group.id);
      if(budget == null) {
        continue;
      }
      group.budget = budget;
      for(var category in group.subCategories) {
        category.budget = budgetJsonRepository.getAt(category.id);
      }
      res.add(group);
    }
    return res;
  }

  CustomCategory getCategoryById(String id, {bool withBudget = true}) {
    final res = repository.getById(id);
    if(withBudget) {
      res.budget = budgetJsonRepository.getAt(id);
    }
    return res;
  }

  void putCategory(TransactCategory newTransactCategory) {
    repository.put(newTransactCategory);
    notifyListeners();
  }

  void putBudget(Budget budget) {
    final parent = repository.getParentByChild(budget.categoryId!);
    if(parent != null) {
      final parentBudget = budgetJsonRepository.getAt(parent.id);
      if(parentBudget == null) {
        budgetJsonRepository.put(Budget(amount: budget.amount, categoryId: parent.id));
      } else {
        parentBudget.amount = parentBudget.amount! + budget.amount!;
        budgetJsonRepository.updateAt(parent.id, parentBudget);
      }
    }
    budgetJsonRepository.put(budget);
    notifyListeners();
  }
}