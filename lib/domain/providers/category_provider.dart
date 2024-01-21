import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/local/repository_impl/category_repo_impl.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/domain/providers/transaction_provider.dart';
import 'package:saving_app/domain/repository/category_repository.dart';

abstract class ICategoryProvider {

}

class CategoryProvider extends ChangeNotifier {
  final BaseCategoryRepository repository;

  CategoryProvider(this.repository);

  void putBudget(Budget newBudget) {
    repository.putNewBudget(newBudget);
    notifyListeners();
  }

  Future<List<CategoryGroup>> getCategoriesWithBudget() async {
    final categories = await repository.getCategoriesAndGroups();
    final res = <CategoryGroup>[];
    for(var group in categories) {
      final gbudget = await repository.getBudget(group.id!);
      if(gbudget == null) {
        continue;
      }
      group.budget = gbudget;
      for(var sub in group.subCategories) {
        final sbudget = await repository.getBudget(sub.id!);
        if(sbudget == null) {
          continue;
        }
        sub.budget = sbudget;
      }
      res.add(group);
    }
    return res;
  }

  Future<int> getTotalBudgetAmount() async {
    final budgets = await getCategoriesWithBudget();
    if(budgets.isEmpty) return 0;
    final total = budgets.fold(0, (previousValue, element) => previousValue + element.budget!.amount!);
    return total;
  }
}

final categoryProvider = Provider((ref) {
  ref.watch(transactionProvider);
  return CategoryProvider(CategoryRepositoryLocalImpl());
});