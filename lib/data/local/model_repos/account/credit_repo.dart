import 'package:saving_app/data/local/file_manager.dart';
import 'package:saving_app/data/local/local_repository.dart';
import 'package:saving_app/data/models/accounts.model.dart';


class CreditRepository extends BaseLocalRepository<Credit> {
  final String repoFileName = "credits.json";
  final String dataKey = "credits";

  CreditRepository(){
    _tryUpdateItemsFromLocal();
  }

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
  List<Credit> getAll() {
    // _tryUpdateItemsFromLocal();
    return items;
  }

  @override
  Credit? getAt(id) {
    if(_isValidId(id)){
      try {
        return items.where((element) => element.id == id).first;
      } catch(e) {
        return null;
      }
    }
    return null;
  }

  @override
  void put(Credit value) {
    items.add(value);
    _saveToLocal();
    notifyListeners();
  }

  @override
  void putAll(List<Credit> values) {
    items.addAll(values);
    _saveToLocal();
    notifyListeners();
  }

  @override
  void updateAt(id, Credit newT) {
    assert(newT.id == id);
    final index = items.indexWhere((element) => element.id == id);
    if(index < 0){
      throw Exception("Replacement not found");
    }
    items[index] = newT;
    _saveToLocal();
    notifyListeners();
  }

  bool _isValidId(dynamic id) {
    return id is String;
  }

  Map<String, dynamic> _itemsToJson() {
    return {
      dataKey : items.map((item) => item.toJson()).toList(),
    };
  }

  void _tryUpdateItemsFromLocal() {
    // items only empty in 2 scenarios:
    // 1. Actually no item is added
    // 2. When open app, need to get items from local
    if(items.isEmpty) {
      try {
        FileManager().readJsonFile(repoFileName)
        .then((json) {
            if(json != null) {
              items.addAll(
                (json[dataKey] as List<dynamic>).map(
                  (creditJson) => Credit.fromJson(creditJson as Map<String, dynamic>)
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

  void _saveToLocal() {
    FileManager().writeJsonFile(repoFileName, _itemsToJson());
  }
}