import 'package:saving_app/constants/built_in_categories.dart';
import 'package:saving_app/data/local/file_manager.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/local/local_repository.dart';

class CategoryRepository extends BaseLocalRepository<TransactCategory> {
  final String repoFileName = "category.json";
  final String budgetRepoName = "budgets.json";
  final String dataKey = "category";
  List<CategoryGroup> _categories = [];

  // List<CategoryGroup> get categories => _categories;

  CategoryRepository(){
    _categories = getCategoriesWithBudget();
    notifyListeners();
  }

  List<CategoryGroup> getByType(TransactionType type) =>
    builtInCategories.where((element) => element.type == type).toList();

  @override
  void deleteAll() {
    // TODO: implement deleteAll
  }

  @override
  void deleteAt(id) {
    // TODO: implement deleteAt
  }

  @override
  List<TransactCategory> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  List<CategoryGroup> getAllCategories() {
    return _categories;
  }

  CustomCategory getById(String id) {
    for(var category in builtInCategories) {
      if(category.id == id) {
        return category;
      }
      final res = category.subCategories.where((e) => e.id == id);
      if(res.isNotEmpty) {
        return res.first;
      }
    }
    throw Exception("No such item. Cant find category with id{$id}");
  }

  List<CategoryGroup> getCategoriesWithBudget() {
    final res = builtInCategories;
    for(var group in res) {
      group.budget = getBudget(group.id!);
      for(var sub in group.subCategories) {
        sub.budget = getBudget(sub.id!);
      }
    }
    return res;
  }

  @override
  TransactCategory? getAt(id) {
    for(var category in builtInCategories) {
      final res = category.subCategories.where(
        (element) => element.id == id
      );
      if(res.isNotEmpty) {
        return res.first;
      }
    }
    throw Exception("No such item. Cant find category with id{$id}");
  }

  CategoryGroup? getParentByChild(String id) {
    for(var category in builtInCategories) {
      final res = category.subCategories.where((e) => e.id == id);
      if(res.isNotEmpty) {
        return category;
      }
    }
    return null;
  }

  @override
  void put(TransactCategory value) {
    
  }

  @override
  void putAll(List<TransactCategory> values) {
    // TODO: implement putAll
  }

  @override
  void updateAt(id, TransactCategory newT) {
    // TODO: implement updateAt
  }

  Budget? getBudget(String categoryId) {
    // FileManager().readJsonFile(budgetRepoName).then(
    //   (data) {
    //     if(data != null /*&& data.containsKey(categoryId)*/) {
    //       return Budget.fromJson(data[categoryId]);
    //     }
    //   }
    // );
    // return null;
    for(var group in _categories) {
      if(group.id == categoryId) return group.budget;
      for(var category in group.subCategories) {
        if(category.id == categoryId) return category.budget;
      }
    }
    return null;
  }

  void putBudget(Budget newBudget) {
    getById(newBudget.categoryId!).budget = newBudget;
    final fileManager = FileManager();
    fileManager.readJsonFile(budgetRepoName).then(
      (data) {
        if(data != null) {
          data[newBudget.categoryId!] = newBudget.toJson();
        } else {
          data = {
            newBudget.categoryId!: newBudget.toJson()
          };
        }
        fileManager.writeJsonFile(budgetRepoName, data);
      }
    );
  }
}

