import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/local/file_manager.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/data/repositories/accounts/credit/credit_repo.dart';

final creditRepoProvider = Provider((ref) => CreditRepositoryImpl());

class CreditRepositoryImpl extends CreditRepository {
  final String filename = "credits.json";
  final String dataKey = "credits";

  @override
  Future<void> deleteCredit(String id) async {
    var data = await loadFromLocal();
    data.removeWhere((element) => element.id == id);
    saveToLocal(data);
  }

  @override
  Future<Credit?> getById(String id) async {
    return (await loadFromLocal()).where((element) => element.id == id).firstOrNull;
  }

  @override
  Future<List<Credit>> getCredits() {
    return loadFromLocal();
  }

  @override
  Future<void> putCredit(Credit newCredit) async {
    final data = await loadFromLocal();
    data.add(newCredit);
    saveToLocal(data);
  }

  @override
  Future<void> updateCredit(Credit newCredit) async {
    final data = await loadFromLocal();
    final newData = data.map((e) => e.id == newCredit.id ? newCredit : e).toList();
    saveToLocal(newData);
  }

  Future<List<Credit>> loadFromLocal() async {
    final json = await FileManager().readJsonFile(filename);
    if(json == null) {
      return [];
    }
    if(!json.containsKey(dataKey)){
      throw Exception();
    }
    final datas = json[dataKey] as List<dynamic>;
    return datas.map((e) => Credit.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveToLocal(List<Credit> data) async {
    await FileManager().writeJsonFile(filename, dataToJson(data));
  }

  Map<String, dynamic> dataToJson(List<Credit> data) {
    return {
      dataKey : data.map((e) => e.toJson()).toList(),
    };
  }
}