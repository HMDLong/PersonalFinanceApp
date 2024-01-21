import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/domain/providers/category_provider.dart';
import 'package:saving_app/presentation/managers/transaction_manager.dart';
import 'package:saving_app/presentation/screens/plan/overall/budget/budgets.tab.dart';
import 'package:saving_app/presentation/screens/shared_widgets/progress_gauge.dart';
import 'package:saving_app/utils/times.dart';

class BudgetSection extends StatefulWidget {
  const BudgetSection({super.key});

  @override
  State<BudgetSection> createState() => _BudgetSectionState();
}

class _BudgetSectionState extends State<BudgetSection> {
  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final transactionProvider = context.watch<TransactionProvider>();
    final totalSpent = transactionProvider.getTotalSpentAmount();
    return FutureBuilder(
      future: categoryProvider.getTotalBudgetAmount(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Đang tải");
        }
        return GestureDetector(
          onTap: () {
            pushNewScreen(context, screen: const BudgetTab());
          },
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: snapshot.data!.abs() == 0 
              ? const SizedBox(
                width: double.infinity,
                height: 40,
                child: Center(
                  child: Column(
                    children: [
                      Text("Chưa có ngân sách"),
                    ],
                  ),
                ),
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text(
                        "Ngân sách tháng này",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Chi tiêt",
                            style: TextStyle(
                              color: Colors.blue
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tổng quỹ tháng ${DateFormat(DateFormat.YEAR_ABBR_MONTH).format(getRangeOfTheMonth().start)}",
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                              child: Text(
                                "${NumberFormat.decimalPattern().format(snapshot.data)} VND",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            LinearProgressGauge(
                              value: totalSpent, 
                              max: snapshot.data!,
                              leadingLabel: "Đã chi",
                              trailingLabel: "Còn lại",
                              trailingValue: max<int>(snapshot.data! - totalSpent, 0),
                              mode: GaugeMode.limit,
                              showOverflow: true,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
