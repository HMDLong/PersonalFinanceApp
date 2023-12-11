// import 'dart:convert';
// import 'dart:io';
import 'package:saving_app/constants/built_in_categories.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:saving_app/models/category.model.dart';
import 'package:saving_app/providers/local/file_manager.dart';
import 'package:saving_app/providers/local/local_repository.dart';
// import 'package:saving_app/providers/local/file_manager.dart';

class CategoryRepository extends BaseLocalRepository<TransactCategory> {
  final String repoFileName = "category.json";
  final String dataKey = "category";

  List<TransactCategory> getByType(bool type) =>
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

  @override
  TransactCategory? getAt(id) {
    for(var category in (builtInCategories + builtInCategories)) {
      final res = category.subCategories.where(
        (element) => element.id == id
      );
      if(res.isNotEmpty) {
        return res.first;
      }
    }
    throw Exception("No such item. Cant find category with id{$id}");
  }

  @override
  void put(TransactCategory value) {
    // TODO: implement put
    notifyListeners();
  }

  @override
  void putAll(List<TransactCategory> values) {
    // TODO: implement putAll
  }

  @override
  void updateAt(id, TransactCategory newT) {
    // TODO: implement updateAt
  }
  
  void _tryUpdateItemsFromLocal() {
    if(items.isEmpty) {
      items.addAll(builtInCategories);
      try {
        FileManager().readJsonFile(repoFileName)
        .then((json) {
            if(json != null) {
              for (var debitJson in (json[dataKey] as List<dynamic>)) {
                
                TransactCategory.fromJson(debitJson as Map<String, dynamic>);
              }
              notifyListeners();
            }
          }
        );
      } catch(e) {
        rethrow;
      }
    }
  }
}

