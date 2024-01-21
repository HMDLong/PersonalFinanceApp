import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:saving_app/data/models/plan_transaction.model.dart';
import 'package:saving_app/presentation/screens/plan/plan_transact/plan_transact_card.dart';
import 'package:saving_app/viewmodels/transact/plan_transact_viewmodel.dart';

class IncomeTab extends ConsumerStatefulWidget {
  const IncomeTab({super.key});

  @override
  ConsumerState<IncomeTab> createState() => _IncomeTabState();
}

class _IncomeTabState extends ConsumerState<IncomeTab> {
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
    // final incomes = context.watch<PlanTransactJsonRepository>().getAll().where((e) => e.amount > 0).toList();
    // final incomes = ref.watch(transactionProvider).getIncomes();
    final incomesFuture = ref.watch(incomeProvider);
    return incomesFuture.when(
      data: (incomes) => incomes.isEmpty
        ? const Center(
          child: Text("Bạn chưa thiết lập thu nhập"),
        )
        : ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            const Text("Tổng thu nhập của bạn"),
            Text("${NumberFormat.decimalPattern().format(
              incomes.fold(0, (previousValue, element) => previousValue + element.amount)
            )} VND"),
            const SizedBox(height: 10,),
            Wrap(
              spacing: 8.0,
              children: ["Sắp tới", "Đã nhận", "Muộn"].asMap()
              .map<int, Widget>(
                (key, value) => MapEntry(key, ChoiceChip(
                  label: Text(value), 
                  selected: key == _currentTab,
                  onSelected: (val) {
                    setState(() {
                      _currentTab = key;
                    });
                  },
                ))
              )
              .values.toList(),
            ),
            const SizedBox(height: 10,),
            Column(
              children: _getTransactionToDisplay(incomes).map((transact) {
                return PlanTransactionCard(planTransaction: transact);
              }).toList(),
            ),
          ],
        ),
      error: (error, stackTrace) => Center(child: Text("$error"),),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}