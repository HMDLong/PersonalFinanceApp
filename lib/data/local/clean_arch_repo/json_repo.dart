import 'package:saving_app/data/local/clean_arch_repo/local_repo.dart';
import 'package:saving_app/data/local/file_manager.dart';

abstract class JsonRepository<T> extends LocalRepository<T> {
  String repoFileName = "";
  String dataKey = "";
  List<T> cacheItems = [];

  void itemsFromJson(Map<String, dynamic> json);
  Map<String, dynamic> itemsToJson();
  bool matchItemId(T item, dynamic id);

  JsonRepository({required String repoName}) {
    repoFileName = "$repoName.json";
    dataKey = repoName;
    _tryUpdateItemsFromLocal();
  }

  @override
  void deleteAll() {
    cacheItems.clear();
    _saveToLocal();
  }

  @override
  void deleteAt(id) {
    cacheItems.removeWhere((item) => matchItemId(item, id));
    _saveToLocal();
  }

  @override
  List<T> getAll() {
    return cacheItems;
  }

  @override
  T? getAt(id) {
    if(id is String){
      try {
        return cacheItems.where((item) => matchItemId(item, id)).first;
      } catch(e) {
        return null;
      }
    }
    return null;
  }

  @override
  void put(T value) {
    cacheItems.add(value);
    _saveToLocal();
  }

  @override
  void putAll(List<T> values) {
    cacheItems.addAll(values);
    _saveToLocal();
  }

  @override
  void updateAt(id, T newT) {
    assert(matchItemId(newT, id));
    final index = cacheItems.indexWhere((item) => matchItemId(item, id));
    if(index < 0){
      throw Exception("Replacement not found");
    }
    cacheItems[index] = newT;
    _saveToLocal();
  }

  void _saveToLocal() {
    assert(repoFileName.isNotEmpty && dataKey.isNotEmpty, "Blank repoName");
    FileManager().writeJsonFile(repoFileName, itemsToJson());
  }

  void _tryUpdateItemsFromLocal() {
    assert(repoFileName.isNotEmpty && dataKey.isNotEmpty, "Blank repoName");
    if(cacheItems.isEmpty) {
      try {
        FileManager().readJsonFile(repoFileName)
        .then((json) {
            if(json != null) {
              itemsFromJson(json);
            }
          }
        );
      } catch(e) {
        rethrow;
      }
    }
  }
}