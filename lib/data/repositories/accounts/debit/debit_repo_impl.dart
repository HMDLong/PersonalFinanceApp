import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/local/file_manager.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/data/repositories/accounts/debit/debit_repo.dart';

final debitRepoProvider = Provider((ref) => DebitRepositoryImpl());

class DebitRepositoryImpl extends DebitRepository {
  final String filename = "debits.json";
  final String dataKey = "debits";

  @override
  Future<void> deleteDebit(String id) async {
    var data = await loadFromLocal();
    data.removeWhere((element) => element.id == id);
    saveToLocal(data);
  }

  @override
  Future<Debit?> getById(String id) async {
    return (await loadFromLocal()).where((element) => element.id == id).firstOrNull;
  }

  @override
  Future<List<Debit>> getDebits() {
    return loadFromLocal();
  }

  @override
  Future<void> putDebit(Debit newDebit) async {
    final data = await loadFromLocal();
    data.add(newDebit);
    saveToLocal(data);
  }

  @override
  Future<void> updateDebit(Debit newDebit) async {
    final data = await loadFromLocal();
    final newData = data.map((e) => e.id == newDebit.id ? newDebit : e).toList();
    saveToLocal(newData);
  }

  Future<List<Debit>> loadFromLocal() async {
    final json = await FileManager().readJsonFile(filename);
    if(json == null) {
      return [];
    }
    if(!json.containsKey(dataKey)){
      throw Exception();
    }
    final datas = json[dataKey] as List<dynamic>;
    return datas.map((e) => Debit.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveToLocal(List<Debit> data) async {
    await FileManager().writeJsonFile(filename, dataToJson(data));
  }

  Map<String, dynamic> dataToJson(List<Debit> data) {
    return {
      dataKey : data.map((e) => e.toJson()).toList(),
    };
  }
}