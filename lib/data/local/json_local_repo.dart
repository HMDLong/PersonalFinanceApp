import 'file_manager.dart';
import 'local_repository.dart';

abstract class JsonLocalRepository<T> extends BaseLocalRepository<T> {
  String repoFileName = "";
  String dataKey = "";

  void itemsFromJson(Map<String, dynamic> json);
  Map<String, dynamic> itemsToJson();
  bool matchItemId(T item, dynamic id);

  JsonLocalRepository({required String repoName}) {
    repoFileName = "$repoName.json";
    dataKey = repoName;
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
    items.removeWhere((item) => matchItemId(item, id));
    _saveToLocal();
    notifyListeners();
  }

  @override
  List<T> getAll() {
    // _tryUpdateItemsFromLocal();
    return items;
  }

  @override
  T? getAt(id) {
    if(id is String){
      // _tryUpdateItemsFromLocal();
      try {
        return items.where((item) => matchItemId(item, id)).first;
      } catch(e) {
        return null;
      }
    }
    return null;
  }

  @override
  void put(T value) {
    items.add(value);
    _saveToLocal();
    notifyListeners();
  }

  @override
  void putAll(List<T> values) {
    items.addAll(values);
    _saveToLocal();
    notifyListeners();
  }

  @override
  void updateAt(id, T newT) {
    assert(matchItemId(newT, id));
    final index = items.indexWhere((item) => matchItemId(item, id));
    if(index < 0){
      throw Exception("Replacement not found");
    }
    items[index] = newT;
    _saveToLocal();
    notifyListeners();
  }

  void _saveToLocal() {
    assert(repoFileName.isNotEmpty && dataKey.isNotEmpty, "Blank repoName");
    FileManager().writeJsonFile(repoFileName, itemsToJson());
  }

  void _tryUpdateItemsFromLocal() {
    assert(repoFileName.isNotEmpty && dataKey.isNotEmpty, "Blank repoName");
    if(items.isEmpty) {
      try {
        FileManager().readJsonFile(repoFileName)
        .then((json) {
            if(json != null) {
              itemsFromJson(json);
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
