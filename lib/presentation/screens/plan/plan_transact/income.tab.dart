import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:saving_app/data/models/plan_transaction.model.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/presentation/screens/plan/plan_transact/plan_transact_card.dart';
import 'package:saving_app/presentation/screens/shared_widgets/progress_gauge.dart';
import 'package:saving_app/utils/times.dart';
import 'package:saving_app/viewmodels/transact/plan_transact_viewmodel.dart';
import 'package:saving_app/viewmodels/transact/transact_viewmodel.dart';

class IncomeTab extends ConsumerStatefulWidget {
  const IncomeTab({super.key});

  @override
  ConsumerState<IncomeTab> createState() => _IncomeTabState();
}

class _IncomeTabState extends ConsumerState<IncomeTab> {
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
    // final incomes = context.watch<PlanTransactJsonRepository>().getAll().where((e) => e.amount > 0).toList();
    // final incomes = ref.watch(transactionProvider).getIncomes();
    final range = getRangeOfTheMonth();
    final today = DateTime.now();
    final incomesFuture = ref.watch(incomeProvider);
    final planIncomes = ref.watch(planIncomesProvider(range));
    final totalIncome = ref.watch(totalExpectedIncomeProvider(range));
    final actualIncome = ref.watch(totalActualIncomeProvider(range));
    return incomesFuture.when(
      data: (incomes) => incomes.isEmpty
        ? const Center(
          child: Text("Bạn chưa thiết lập thu nhập"),
        )
        : ListView(
          // physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text("Thu nhập Th${today.month} ${today.year}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  LinearProgressGauge(
                    value: actualIncome.abs(), 
                    max: totalIncome.abs(),
                    leadingLabel: "Thực thu",
                    trailingLabel: "Dự kiến",
                    mode: GaugeMode.goodOverflow,
                  )
                ],
              ),
            ),
            Wrap(
              spacing: 8.0,
              children: ["Sắp tới", "Đã nhận", "Muộn"].asMap()
              .map<int, Widget>(
                (key, value) => MapEntry(key, ChoiceChip(
                  label: Text(value, style: TextStyle(color: key == _currentTab ? Colors.white : Colors.black),), 
                  selected: key == _currentTab,
                  onSelected: (val) {
                    setState(() {
                      _currentTab = key;
                    });
                  },
                  selectedColor: Colors.blue,
                  backgroundColor: Colors.pink.shade50,
                ))
              )
              .values.toList(),
            ),
            const SizedBox(height: 10,),
            Column(
              children: _getTransactionToDisplay(planIncomes.toList()..sort((a,b) => a.timestamp.toDateOnly().compareTo(b.timestamp.toDateOnly()))).map((transact) {
                return PlanTransactionCard(planTransaction: transact);
              }).toList(),
            ),
            const SizedBox(height: 60,)
          ],
        ),
      error: (error, stackTrace) => Center(child: Text("$error"),),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}