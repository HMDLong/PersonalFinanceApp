import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:saving_app/data/models/plan_transaction.model.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/domain/providers/transaction_provider.dart';
import 'package:saving_app/presentation/screens/plan/plan_transact/plan_transact_card.dart';
import 'package:saving_app/presentation/screens/shared_widgets/progress_gauge.dart';
import 'package:saving_app/utils/times.dart';
import 'package:saving_app/viewmodels/transact/plan_transact_viewmodel.dart';
import 'package:saving_app/viewmodels/transact/transact_viewmodel.dart';

class ExpenseTab extends ConsumerStatefulWidget {
  const ExpenseTab({super.key});

  @override
  ConsumerState<ExpenseTab> createState() => _ExpenseTabState();
}

class _ExpenseTabState extends ConsumerState<ExpenseTab> {
  int _currentTab = 0;

  List<Transaction> _getTransactionToDisplay(List<Transaction> planTransacts) {
    return planTransacts.where((transact) {
      return switch(_currentTab) {
        0 => transact.paid == false,
        1 => transact.paid == true,
        2 => true,
        _ => false
      }; 
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // final expenses = context.watch<PlanTransactJsonRepository>().getAll().where((e) => e.amount < 0).toList();
    final range = getRangeOfTheMonth();
    final expenses = ref.watch(planExpensesProvider(range));
    // .when<List<PlanTransaction>>(
    //   data: (data) => data, 
    //   error: (error, _) => [], 
    //   loading: () => []
    // );
    
    final totalExpense = ref.watch(totalExpectedExpenseProvider(range));
    final actualExpense = ref.watch(totalActualExpenseProvider(range));
    final today = DateTime.now();
    return expenses.isEmpty
    ? const SizedBox.expand(
        child: Center(
          child: Text("Bạn chưa thiết lập khoản chi tiêu"),
        ),
      )
    : ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Tổng chi tiêu Th${today.month} ${today.year}",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              // Text(
              //   "${NumberFormat.decimalPattern().format(actualExpense)}/${NumberFormat.decimalPattern().format(totalExpense)} VND",
              //   style: const TextStyle(fontSize: 18),
              // ),
              LinearProgressGauge(
                value: actualExpense.abs(), 
                max: totalExpense.abs(),
                mode: GaugeMode.limit,
                leadingLabel: "Thực chi",
                trailingLabel: "Dự kiến",
              ),
            ],
          ),
        ),
        Wrap(
          spacing: 8.0,
          children: ["Sắp tới", "Đã chi", "Muộn"].asMap()
          .map<int, Widget>(
            (key, value) => MapEntry(key, ChoiceChip(
              label: Text(value, style: TextStyle(color: key == _currentTab ? Colors.white : Colors.black)), 
              selected: key == _currentTab,
              onSelected: (val) {
                setState(() {
                  _currentTab = key;
                });
              },
              selectedColor: Colors.blue,
              backgroundColor: Colors.pink.shade50,
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(10),
              //   side: const BorderSide(width: 0.3),
              // ),
            ))
          )
          .values.toList(),
        ),
        const SizedBox(height: 10,),
        Column(
          children: _getTransactionToDisplay(expenses.toList()).map((transact) {
            return PlanTransactionCard(planTransaction: transact);
          }).toList(),
        ),
      ],
    );
  }
}