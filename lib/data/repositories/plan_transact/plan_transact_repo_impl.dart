import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/local/file_manager.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/plan_transaction.model.dart';
import 'package:saving_app/data/repositories/plan_transact/plan_transact_repo.dart';

final planTransactRepoProvider = Provider((ref) => PlanTransactionRepositoryImpl());

class PlanTransactionRepositoryImpl extends PlanTransactionRepository {
  final String filename = "plan_transactions.json";
  final String dataKey = "plan_transactions";

  // late final List<PlanTransaction> _cache; //= <PlanTransaction>[];

  // PlanTransactionRepositoryImpl() {
  //   _loadFromLocal().then((res) {
  //     // _cache.addAll(res);
  //     _cache = res;
  //   });
  // }

  @override
  Future<List<PlanTransaction>> getPlanTransacts() {
    return _loadFromLocal();
  }

  @override
  Future<PlanTransaction?> getPlanTransactById(String id) async {
    final datas = await _loadFromLocal();
    return datas.where((e) => e.id == id).firstOrNull;
  }

  @override
  Future<List<PlanTransaction>> getPlanTransactsByType(TransactionType type) async {
    final datas = await _loadFromLocal();
    return datas.where((e) => e.transactType == type).toList();
  }

  @override
  Future<void> putPlanTransact(PlanTransaction newPlanTransact) async {
    final data = await _loadFromLocal();
    data.add(newPlanTransact);
    _saveToLocal(data);
  }

  @override
  Future<void> updatePlanTransact(PlanTransaction updatedTransact) async {
    var data = await _loadFromLocal();
    data[data.indexWhere((e) => e.id == updatedTransact.id)] = updatedTransact;
    _saveToLocal(data);
  }

  Future<List<PlanTransaction>> _loadFromLocal() async {
    final value = await FileManager().readJsonFile(filename);
    if(value != null) {
      final datas =  value[dataKey] as List<dynamic>;
      return datas.map((json) => PlanTransaction.fromJson(json as Map<String, dynamic>)).toList();
    }
    // throw Exception("PlanTransactionRepoImpl: null data key");
    return [];
  }

  void _saveToLocal(List<PlanTransaction> data) async {
    await FileManager().writeJsonFile(filename, _dataToMap(data));
  }

  Map<String, dynamic> _dataToMap(List<PlanTransaction> data) => {
    dataKey: data.map((e) => e.toJson()).toList(),
  };
}