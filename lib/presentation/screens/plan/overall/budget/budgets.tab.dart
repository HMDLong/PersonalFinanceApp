// import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/domain/providers/category_provider.dart';
import 'package:saving_app/presentation/managers/transaction_manager.dart';
import 'package:saving_app/presentation/screens/plan/overall/budget/new_budget.screen.dart';
import 'package:saving_app/presentation/screens/shared_widgets/budget_card.dart';
import 'package:saving_app/presentation/screens/style/styles.dart';
import 'package:saving_app/utils/times.dart';

class BudgetTab extends StatefulWidget {
  const BudgetTab({super.key});

  @override
  State<BudgetTab> createState() => _BudgetTabState();
}

class _BudgetTabState extends State<BudgetTab> {

  @override
  Widget build(BuildContext context) {
    final categoryController = context.watch<CategoryProvider>();
    final transactionController = context.watch<TransactionProvider>();
    return Scaffold(
      appBar: defaultStyledAppBar(
        onBackPressed: () => Navigator.of(context).pop(), 
        title: "Ngân quỹ của bạn"
      ),
      body: FutureBuilder(
        future: categoryController.getCategoriesWithBudget(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Đang tải");
          } else {
            if(snapshot.hasError) {
              return const Text("Đã có lỗi xảy ra");
            } else {
              final budgets_ = snapshot.data!;
              final totalBudget = budgets_.fold(0, (prev, value) => prev + value.budget!.amount!);
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Budget ${DateFormat(DateFormat.YEAR_ABBR_MONTH).format(DateTime.now())}"
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            NumberFormat.decimalPattern().format(transactionController.getTotalSpentAmount()),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            "/${NumberFormat.decimalPattern().format(totalBudget)} VND",
                            style: const TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final item = budgets_[index];
                          final subs = item.subCategories.where((element) => element.budget != null).toList();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              BudgetCard(entry: BudgetEntry(
                                amount: transactionController.getSumOfCategoryInRange(
                                  item.id!, 
                                  getRangeOfTheMonth()
                                ),
                                budget: item.budget, 
                                category: item
                              )),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: subs.length, 
                                  itemBuilder: (context, i) {
                                    final subCate = subs[i];
                                    return BudgetCard(
                                      entry: BudgetEntry(
                                        budget: subCate.budget,
                                        category: subCate, 
                                        amount: transactionController.getSumOfCategoryInRange(
                                          item.id!, 
                                          getRangeOfTheMonth()
                                        ),
                                      ),
                                      showTimeRange: false,
                                    );
                                  }
                                ),
                              )
                            ],
                          );
                        },
                        itemCount: budgets_.length,
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(CupertinoIcons.add),
        onPressed: () {
          pushNewScreen(context, screen: const NewBudgetScreen());
        },
      ),
    );
  }
}
