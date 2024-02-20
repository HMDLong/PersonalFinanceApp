import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/local/file_manager.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/data/repositories/accounts/saving/saving_repo.dart';

final savingRepoProvider = Provider((ref) => SavingRepositoryImpl());

class SavingRepositoryImpl extends SavingRepository {
  final String filename = "savings.json";
  final String dataKey = "savings";
  
  @override
  Future<void> deleteSaving(String id) async {
    final data = await loadFromLocal();
    data.removeWhere((element) => element.id == id);
    await saveToLocal(data);
  }

  @override
  Future<Saving?> getById(String id) async {
    final datas = await loadFromLocal();
    return datas.where((element) => element.id == id).firstOrNull;
  }

  @override
  Future<List<Saving>> getSavings() {
    return loadFromLocal();
  }

  @override
  Future<void> putSaving(Saving newSaving) async {
    final datas = await loadFromLocal();
    saveToLocal(datas..add(newSaving));
  }

  @override
  Future<void> updateSaving(Saving newSaving) async {
    final datas = await loadFromLocal();
    final newDatas = datas.map((e) => e.id == newSaving.id ? newSaving : e).toList();
    await saveToLocal(newDatas);
  }

  Future<List<Saving>> loadFromLocal() async {
    final json = await FileManager().readJsonFile(filename);
    if(json == null) {
      return [];
    }
    if(!json.containsKey(dataKey)){
      throw Exception();
    }
    final datas = json[dataKey] as List<dynamic>;
    return datas.map((e) => Saving.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveToLocal(List<Saving> data) async {
    await FileManager().writeJsonFile(filename, dataToJson(data));
  }

  Map<String, dynamic> dataToJson(List<Saving> data) {
    return {
      dataKey : data.map((e) => e.toJson()).toList(),
    };
  }
}