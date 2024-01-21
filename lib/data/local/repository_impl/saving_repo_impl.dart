import 'package:saving_app/data/local/file_manager.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/domain/repository/saving_repository.dart';

class SavingRepositoryLocalImpl extends BaseSavingRepository {
  final String filename = "savings.json";
  final String dataKey = "savings";
  final List<Saving> _cache = [];

  SavingRepositoryLocalImpl() {
    _getFromJsonLocal().then((value) {
      if(value != null) {
        _cache.addAll(value);
      }}
    );
  }

  @override
  Future<List<Saving>> getSavings() async {
    return _cache;
  }

  @override
  Future<void> putNewSaving(Saving newSaving) async {
    _cache.add(newSaving);
    _saveToLocal();
  }

  Map<String, dynamic> _cacheToJson() {
    return {
      dataKey: _cache.map((e) => e.toJson()).toList(),
    };
  }

  Future<List<Saving>?> _getFromJsonLocal() async {
    final data = await FileManager().readJsonFile(filename);
    if(data == null) {
      return null;
    }
    if(!data.containsKey(dataKey)) {
      throw Exception();
    }
    final dataList = data[dataKey] as List<dynamic>;
    return dataList.map((json) => Saving.fromJson(json as Map<String, dynamic>)).toList();
  }

  _saveToLocal() {
    FileManager().writeJsonFile(filename, _cacheToJson());
  }
}