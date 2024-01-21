// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/local/file_manager.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/domain/repository/debts_repository.dart';

class DebtRepositoryLocalImpl extends DebtsRepository {
  final String filename = "debts.json";
  final String dataKey = "debts";
  final List<Debt> _cache = [];

  DebtRepositoryLocalImpl() {
    _loadAllFromLocal().then((value) {
      if(value != null) {
        _cache.addAll(value);
      }}
    );
  }

  @override
  Future<List<Debt>> getDebts() async {
    return _cache;
  }

  @override
  Future<Debt?> getById(String id) async {
    final res = _cache.where((e) => e.id == id);
    return res.isEmpty ? null : res.first;  
  }

  @override
  Future<void> putDebt(Debt newDebt) async {
    _cache.add(newDebt);
    _saveToLocal();
  }

  @override
  Future<void> updateDebt(String id, Debt updatedDebt) async {
    // TODO: implement updateDebt
  }

  Future<List<Debt>?> _loadAllFromLocal() async {
    final json = await FileManager().readJsonFile(filename);
    if(json == null) {
      return null;
    }
    if(!json.containsKey(dataKey)) {
      throw Exception();
    }
    final datas = json[dataKey] as List<dynamic>;
    return datas.map((e) => Debt.fronJson(e as Map<String, dynamic>)).toList();
  }

  void _saveToLocal() {
    FileManager().writeJsonFile(filename, _cacheToJson());
  }

  Map<String, dynamic> _cacheToJson() {
    return {
      dataKey: _cache.map((e) => e.toJson()).toList(),
    };
  }
}

// final debtRepoProvider = Provider((ref) {
//   return DebtRepositoryLocalImpl();
// });

