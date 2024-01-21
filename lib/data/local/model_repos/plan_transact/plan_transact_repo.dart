import 'package:saving_app/data/models/plan_transaction.model.dart';
import 'package:saving_app/data/local/json_local_repo.dart';

class PlanTransactJsonRepository extends JsonLocalRepository<PlanTransaction> {
  PlanTransactJsonRepository({required String repoName}) : super(repoName: repoName);
  
  @override
  void itemsFromJson(Map<String, dynamic> json) {
    items.addAll(
      (json[dataKey] as List<dynamic>).map(
        (debitJson) => PlanTransaction.fromJson(debitJson as Map<String, dynamic>)
      ).toList()
    );
  }
  
  @override
  Map<String, dynamic> itemsToJson() {
    return {
      dataKey : items.map((item) => item.toJson()).toList(),
    };
  }
  
  @override
  bool matchItemId(PlanTransaction item, id) {
    return item.id == (id as String);
  }
}