import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/local/file_manager.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/data/repositories/accounts/debt/debt_repo.dart';

final debtRepoProvider = Provider((ref) => DebtRepositoryImpl());

class DebtRepositoryImpl extends DebtRepository {
  final String filename = "debts.json";
  final String dataKey = "debts";

  @override
  Future<Debt?> getDebtById(String id) async {
    final datas = await loadFromLocal();
    return datas.where((element) => element.id == id).firstOrNull;
  }

  @override
  Future<List<Debt>> getDebts() {
    return loadFromLocal();
  }

  @override
  Future<void> putDebt(Debt newDebt) async {
    final datas = await loadFromLocal();
    saveToLocal(datas..add(newDebt));
  }

  @override
  Future<void> updateDebt(Debt newDebt) async {
    final datas = await loadFromLocal();
    final newDatas = datas.map((e) => e.id == newDebt.id ? newDebt : e).toList();
    await saveToLocal(newDatas);
  }

  @override
  Future<void> deleteDebt(String id) async {
    final data = await loadFromLocal();
    data.removeWhere((element) => element.id == id);
    await saveToLocal(data);
  }

  Future<List<Debt>> loadFromLocal() async {
    final json = await FileManager().readJsonFile(filename);
    if(json == null) {
      return [];
    }
    if(!json.containsKey(dataKey)){
      throw Exception();
    }
    final datas = json[dataKey] as List<dynamic>;
    return datas.map((e) => Debt.fronJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveToLocal(List<Debt> data) async {
    await FileManager().writeJsonFile(filename, dataToJson(data));
  }

  Map<String, dynamic> dataToJson(List<Debt> data) {
    return {
      dataKey : data.map((e) => e.toJson()).toList(),
    };
  }
}