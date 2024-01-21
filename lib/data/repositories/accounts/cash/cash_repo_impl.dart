import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/local/file_manager.dart';
import 'package:saving_app/data/repositories/accounts/cash/cash_repo.dart';

class CashRepositoryImpl extends CashRepository {
  final String filename = "cash.json";
  final String dataKey = "cash";

  @override
  Future<int> getCashAmount() async {
    final data = await FileManager().readJsonFile(filename);
    if(data == null) {
      return 0;
    }
    return data[dataKey] as int;
  }

  @override
  Future<void> setCashAmount(int newAmount) async {
    await FileManager().writeJsonFile(filename, {dataKey: newAmount});
  }
}

final cashRepoProvider = Provider((ref) => CashRepositoryImpl());