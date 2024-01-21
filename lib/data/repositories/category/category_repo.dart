import 'package:saving_app/data/models/category.model.dart';

abstract class CategoryRepository {
  Future<List<CategoryGroup>> getCategoriesWithGroup({withBudget = false});
  Future<List<TransactCategory>> getCategoriesNoGroup({withBudget = false});
  Future<CustomCategory?> getById(String id, {withBudget = false});
  Future<List<CategoryGroup>> getByType(TransactionType type, {withBudget = false});
  Future<void> putCategory(String parentId, TransactCategory newCategory);
  Future<void> updateCategory(TransactCategory newCategory);
  Future<void> deleteCategory(String id);
}