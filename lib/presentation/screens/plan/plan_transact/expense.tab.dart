import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:saving_app/data/models/plan_transaction.model.dart';
import 'package:saving_app/domain/providers/transaction_provider.dart';
import 'package:saving_app/presentation/screens/plan/plan_transact/plan_transact_card.dart';
import 'package:saving_app/viewmodels/transact/plan_transact_viewmodel.dart';

class ExpenseTab extends ConsumerStatefulWidget {
  const ExpenseTab({super.key});

  @override
  ConsumerState<ExpenseTab> createState() => _ExpenseTabState();
}

class _ExpenseTabState extends ConsumerState<ExpenseTab> {
  int _currentTab = 0;

  List<PlanTransaction> _getTransactionToDisplay(List<PlanTransaction> planTransacts) {
    return planTransacts.where((transact) {
      return switch(_currentTab) {
        0 => transact.status == PaidStatus.upcoming,
        1 => transact.status == PaidStatus.paid,
        2 => transact.status == PaidStatus.late,
        _ => false
      }; 
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // final expenses = context.watch<PlanTransactJsonRepository>().getAll().where((e) => e.amount < 0).toList();
    final expenses = ref.watch(expensesProvider).when<List<PlanTransaction>>(
      data: (data) => data, 
      error: (error, _) => [], 
      loading: () => []
    );
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
        Text("Tổng chi tiêu ${DateFormat.yMMMM().format(DateTime.now())}"),
        Text("${NumberFormat.decimalPattern().format(
          expenses.fold(0, (previousValue, element) => previousValue + element.amount)
        )} VND"),
        const SizedBox(height: 10,),
        Wrap(
          spacing: 8.0,
          children: ["Sắp tới", "Đã chi", "Muộn"].asMap()
          .map<int, Widget>(
            (key, value) => MapEntry(key, ChoiceChip(
              label: Text(value), 
              selected: key == _currentTab,
              onSelected: (val) {
                setState(() {
                  _currentTab = key;
                });
              },
              selectedColor: Colors.blue,
              backgroundColor: Colors.pink.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(width: 0.3),
              ),
            ))
          )
          .values.toList(),
        ),
        const SizedBox(height: 10,),
        Column(
          children: _getTransactionToDisplay(expenses).map((transact) {
            return PlanTransactionCard(planTransaction: transact);
          }).toList(),
        ),
      ],
    );
  }
}