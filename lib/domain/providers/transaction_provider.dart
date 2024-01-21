import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/constants/constants.dart';
import 'package:saving_app/data/local/model_repos/plan_transact/plan_transact_repo.dart';
import 'package:saving_app/data/local/model_repos/records/transact_repo.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/presentation/managers/transaction_manager.dart';

final transactionProvider = ChangeNotifierProvider(
  (ref) => TransactionProvider(
    transactRepo: TransactionRepository(), 
    planTransactRepo: PlanTransactJsonRepository(repoName: planTransactRepoName)
  )
);

final actualIncomeProvider = Provider((ref) {
  final incomes = ref.watch(transactionProvider).getByType(TransactionType.income);
  return incomes.fold(0, (prev, e) => prev + e.amount);
});
