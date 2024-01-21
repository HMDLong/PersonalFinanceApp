import 'package:saving_app/data/models/category.model.dart';

abstract class BaseCategoryRepository {
  // Create
  Future<void> putNewCategory(TransactCategory newTransactCategory);
  Future<void> putNewBudget(Budget newBudget);
  // Read
  Future<List<CategoryGroup>> getCategoriesAndGroups();
  Future<CategoryGroup?> getCategoriesByGroup(String groupId);
  Future<CustomCategory?> getCategoryById(String id);
  Future<Budget?> getBudget(String categoryId);
  // Delete
  Future<void> removeBudget(String budgetId);
  Future<void> removeCategory(String categoryId);
}
