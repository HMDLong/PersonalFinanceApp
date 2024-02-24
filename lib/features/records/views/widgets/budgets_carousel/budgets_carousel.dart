import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/domain/providers/category_provider.dart';
import 'package:saving_app/presentation/managers/category_manager.dart';
import 'package:saving_app/presentation/managers/transaction_manager.dart';
import 'package:saving_app/presentation/screens/shared_widgets/budget_card.dart';
import 'package:saving_app/utils/times.dart';

class BudgetsCarousel extends StatefulWidget {
  const BudgetsCarousel({super.key});

  @override
  State<StatefulWidget> createState() => _BudgetsCarouselState();
}

class _BudgetsCarouselState extends State<BudgetsCarousel>{

  @override
  Widget build(BuildContext context) {
    // final budgets = context.watch<PlanController>().getBudgetsWithProgress(getRangeOfTheMonth());
    // final budgets_ = context.watch<CategoryProvider>().getCategoriesWithBudget();
    final controller = context.watch<CategoryProvider>();
    // print(budgets_);
    final transactionController = context.read<TransactionProvider>();
    return FutureBuilder(
      future: controller.getCategoriesWithBudget(),
      builder: (context, snapshot) {
        switch(snapshot.connectionState){
          case ConnectionState.waiting: return const Text("");
          default:
            if(snapshot.hasError){
              return Text("error: ${snapshot.error}");
            } else {
              return SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    return item.budget == null 
                    ? null
                    : BudgetCard(entry: BudgetEntry(
                        amount: transactionController.getSumOfCategoryInRange(
                          item.id!, 
                          getRangeOfTheMonth()
                        ),
                        budget: item.budget!, 
                        category: item,
                      ));
                  },
                  itemCount: snapshot.data!.length,
                ),
              ); 
            }
        }
      }
    );
  }
}