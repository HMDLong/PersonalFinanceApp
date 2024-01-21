import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/repositories/category/category_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryRepoProvider = Provider((ref) => CategoryRepositoryImpl());

class CategoryRepositoryImpl extends CategoryRepository {
  final String categoryFilename = "custom_categories.json";
  final String categoryDataKey = "categories";
  final String budgetDataKey = "budgets";
  final String budgetFilename = "budgets.json";

  @override
  Future<void> deleteCategory(String id) {
    // TODO: implement deleteCategory
    throw UnimplementedError();
  }

  @override
  Future<CustomCategory?> getById(String id, {withBudget = false}) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<CategoryGroup>> getByType(TransactionType type, {withBudget = false}) {
    // TODO: implement getByType
    throw UnimplementedError();
  }

  @override
  Future<List<TransactCategory>> getCategoriesNoGroup({withBudget = false}) {
    // TODO: implement getCategoriesNoGroup
    throw UnimplementedError();
  }

  @override
  Future<List<CategoryGroup>> getCategoriesWithGroup({withBudget = false}) {
    // TODO: implement getCategoriesWithGroup
    throw UnimplementedError();
  }

  @override
  Future<void> putCategory(String parentId, TransactCategory newCategory) {
    // TODO: implement putCategory
    throw UnimplementedError();
  }

  @override
  Future<void> updateCategory(TransactCategory newCategory) {
    // TODO: implement updateCategory
    throw UnimplementedError();
  }

  // Future<List<T>> loadFromLocal<T>(String filename, String dataKey) async {
  //   final json = await FileManager().readJsonFile(filename);
  //   if(json == null) {
  //     return [];
  //   }
  //   if(!json.containsKey(dataKey)){
  //     throw Exception();
  //   }
  //   final datas = json[dataKey] as List<dynamic>;
  //   return datas.map((e) => T.fromJson(e as Map<String, dynamic>)).toList();
  // }

  // Future<void> saveToLocal(List<Debt> data) async {
  //   await FileManager().writeJsonFile(filename, dataToJson(data));
  // }

  // Map<String, dynamic> dataToJson(List<Debt> data, String dataKey) {
  //   return {
  //     dataKey : data.map((e) => e.toJson()).toList(),
  //   };
  // }
}