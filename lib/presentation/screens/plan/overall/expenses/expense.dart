import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:saving_app/data/models/plan/income_dist.dart';
import 'package:saving_app/presentation/screens/plan/plan_transact/plan_transaction.tab.dart';
import 'package:saving_app/presentation/screens/shared_widgets/progress_gauge.dart';
import 'package:saving_app/presentation/screens/stats/widgets/category_pie_chart.dart';
import 'package:saving_app/utils/times.dart';
import 'package:saving_app/viewmodels/transact/transact_viewmodel.dart';

class ExpenseSection extends ConsumerStatefulWidget {
  const ExpenseSection({super.key});

  @override
  ConsumerState<ExpenseSection> createState() => _ExpenseSectionState();
}

class _ExpenseSectionState extends ConsumerState<ExpenseSection> {

  @override
  Widget build(BuildContext context) {
    final range = getRangeOfTheMonth();
    final totalExpenses = ref.watch(totalExpectedExpenseProvider(range));
    final actualExpenses = ref.watch(totalActualExpenseProvider(range));
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: GestureDetector(
        onTap: () {
          pushNewScreen(context, screen: const PlanTransactionTab.expense());
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Row(
                children: [
                  Text(
                    "Khoản chi",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Chi tiết",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 5,),
              const Text("Chi tiêu tháng này"),
              const SizedBox(height: 5,),
              LinearProgressGauge(
                value: actualExpenses.abs(), 
                max: totalExpenses.abs(),
                mode: GaugeMode.limit,
                leadingLabel: "Thực chi",
                trailingLabel: "Dự kiến",
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _getStringTitle(ExpensesLevel dataKey) {
    return switch(dataKey) {
      ExpensesLevel.expense => "Tổng chi phí",
      ExpensesLevel.nescessity => "Chi phí cần thiết",
      ExpensesLevel.personal => "Chi tiêu cá nhân",
      ExpensesLevel.saving => "Tiết kiệm"
    };
  }
}