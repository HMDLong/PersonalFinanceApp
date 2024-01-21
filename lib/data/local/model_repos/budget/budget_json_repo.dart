import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/local/json_local_repo.dart';

class BudgetJsonRepository extends JsonLocalRepository<Budget> {
  BudgetJsonRepository({required String repoName}) : super(repoName: repoName);
  
  @override
  void itemsFromJson(Map<String, dynamic> json) {
    items.addAll(
      (json[dataKey] as List<dynamic>).map(
        (debitJson) => Budget.fromJson(debitJson as Map<String, dynamic>)
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
  bool matchItemId(Budget item, id) {
    return item.categoryId == (id as String);
  }
}
