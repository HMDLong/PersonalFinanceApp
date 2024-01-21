import 'package:saving_app/constants/built_in_categories.dart';
import 'package:saving_app/data/local/file_manager.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/domain/repository/category_repository.dart';

class CategoryRepositoryLocalImpl extends BaseCategoryRepository {
  final String cateFile = "custom_categories.json";
  final String budgetFile = "budgets.json";
  final _cache = <CategoryGroup>[];

  CategoryRepositoryLocalImpl() {
    final tmp = builtInCategories;
    for(var group in tmp) {
      getBudget(group.id!).then((value) => group.budget = value);
      for(var subCate in group.subCategories) {
        getBudget(subCate.id!).then((value) => subCate.budget = value);
      }
    }
    _cache.addAll(tmp);
  }

  @override
  Future<Budget?> getBudget(String categoryId) async {
    final budgets = await FileManager().readJsonFile(budgetFile);
    if(budgets == null) {
      return null;
    }
    if(!budgets.containsKey(categoryId)){
      return null;
    }
    return Budget.fromJson(budgets[categoryId] as Map<String, dynamic>);
  }

  @override
  Future<List<CategoryGroup>> getCategoriesAndGroups() async {
    return builtInCategories;
  }

  @override
  Future<CategoryGroup?> getCategoriesByGroup(String groupId) async {
    final res = builtInCategories.where((category) => category.id == groupId);
    if(res.isEmpty) {
      return null;
    }
    return res.first;
  }

  @override
  Future<CustomCategory?> getCategoryById(String id) async {
    for(var group in builtInCategories) {
      if(group.id == id) {
        return group;
      }
      for(var subCate in group.subCategories) {
        if(subCate.id == id) {
          return subCate;
        }
      }
    }
    return null;
  }

  @override
  Future<void> putNewBudget(Budget newBudget) async {
    var data = await FileManager().readJsonFile(budgetFile) ?? {};
    for(var group in builtInCategories) {
      if(group.id == newBudget.categoryId) {
        data[group.id!] = newBudget;
        FileManager().writeJsonFile(budgetFile, data);
        return;
      }
      for(var subCate in group.subCategories) {
        if(subCate.id == newBudget.categoryId) {
          if(data.containsKey(group.id)){
            data[group.id!]["amount"] = data[group.id]["amount"] + newBudget.amount;
          } else {
            data[group.id!] = Budget(amount: newBudget.amount, categoryId: group.id).toJson();
          }
          data[subCate.id!] = newBudget;
          FileManager().writeJsonFile(budgetFile, data);
        }
      }
    }
  }

  @override
  Future<void> putNewCategory(TransactCategory newTransactCategory) {
    // TODO: implement putNewCategory
    throw UnimplementedError();
  }

  @override
  Future<void> removeBudget(String budgetId) {
    // TODO: implement removeBudget
    throw UnimplementedError();
  }

  @override
  Future<void> removeCategory(String categoryId) {
    // TODO: implement removeCategory
    throw UnimplementedError();
  }
}