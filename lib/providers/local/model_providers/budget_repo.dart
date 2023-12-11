import 'package:saving_app/models/budget.model.dart';
import 'package:saving_app/providers/local/local_repository.dart';
import '../file_manager.dart';

class BudgetRepository extends BaseLocalRepository<Budget> {
  final String repoFileName = "budgets.json";
  final String dataKey = "budgets";

  @override
  void deleteAll() {
    items.clear();
    _saveToLocal();
    notifyListeners();
  }

  @override
  void deleteAt(id) {
    items.removeWhere((element) => element.id == id);
    _saveToLocal();
    notifyListeners();
  }

  @override
  List<Budget> getAll() {
    _tryUpdateItemsFromLocal();
    return items;
  }

  @override
  Budget? getAt(id) {
    if(id is String){
      try {
        return items.where((element) => element.id == id).first;
      } catch(e) {
        return null;
      }
    }
    return null;
  }

  @override
  void put(Budget value) {
    items.add(value);
    _saveToLocal();
    notifyListeners();
  }

  @override
  void putAll(List<Budget> values) {
    items.addAll(values);
    _saveToLocal();
    notifyListeners();
  }

  @override
  void updateAt(id, Budget newT) {
    assert(newT.id == id);
    final index = items.indexWhere((element) => element.id == id);
    if(index < 0){
      throw Exception("Replacement not found");
    }
    items[index] = newT;
    _saveToLocal();
    notifyListeners();
  }

  void _saveToLocal() {
    FileManager().writeJsonFile(repoFileName, _itemsToJson());
  }
  
  Map<String, dynamic> _itemsToJson() {
    return {
      dataKey : items.map((item) => item.toJson()).toList(),
    };
  }
  
  void _tryUpdateItemsFromLocal() {
    if(items.isEmpty) {
      try {
        FileManager().readJsonFile(repoFileName)
        .then((json) {
            if(json != null) {
              items.addAll(
                (json[dataKey] as List<dynamic>).map(
                  (debitJson) => Budget.fromJson(debitJson as Map<String, dynamic>)
                ).toList()
              );
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