import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/presentation/managers/transaction_manager.dart';
import 'package:saving_app/presentation/screens/plan/overall/budget/budget_detail.dart';
import 'package:saving_app/presentation/screens/shared_widgets/progress_gauge.dart';
import 'package:saving_app/utils/times.dart';

class BudgetCard extends StatefulWidget {
  final BudgetEntry entry;
  final bool isCompact;
  final bool showTimeRange;

  const BudgetCard({
    super.key, 
    required this.entry, 
    this.isCompact = true,
    this.showTimeRange = true,
  });

  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class BudgetEntry {
  Budget? budget;
  CustomCategory category;
  int amount;

  BudgetEntry({
    required this.budget,
    required this.category,
    required this.amount,  
  });

  factory BudgetEntry.fromMap(Map<String, dynamic> datas) {
    return BudgetEntry(
      budget: datas["budget"], 
      category: datas["category"], 
      amount: datas["spentAmount"],
    );
  }
}

class _BudgetCardState extends State<BudgetCard> {
  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final category = widget.entry.category;
    final amount = category is CategoryGroup
    ? transactionProvider.getSumOfCategoriesInRange(category.subCategories.map((e) => e.id!).toList(), getRangeOfTheMonth())
    : category is TransactCategory
      ? transactionProvider.getSumOfCategoryInRange(category.id!, getRangeOfTheMonth())
      : -1;
    return GestureDetector(
      onTap: () {
        pushNewScreen(context, screen: const BudgetDetail());
      },
      child: SizedBox(
        width: 200,
        height: 120,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: Colors.blue.shade300,
              width: 0.5
            )
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.entry.category.name}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                widget.showTimeRange
                ? Text("${
                  widget.entry.budget == null
                  ? 0
                  : switch(widget.entry.budget!.period) {
                    BudgetPeriod.weekly => getRangeOfTheWeek(),
                    BudgetPeriod.monthly => getRangeOfTheMonth(),
                    BudgetPeriod.yearly => getRangeOfTheYear(),
                    null => "",
                  }
                }", style: const TextStyle(fontSize: 10),)
                : const SizedBox(height: 0.1,),
                LinearProgressGauge(
                  value: amount.abs(), 
                  max: widget.entry.budget!.amount!,
                  trailingValue: widget.entry.budget!.amount!,
                  labelFontSize: 10,
                  valueFontSize: 10,
                  showOverflow: true,
                  mode: GaugeMode.limit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BudgetCardContent extends StatelessWidget {
  const BudgetCardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}