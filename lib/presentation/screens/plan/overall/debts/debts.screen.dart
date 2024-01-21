import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/data/models/plan/debt_strat.dart';
import 'package:saving_app/presentation/screens/accounts/new_account.screen.dart';
import 'package:saving_app/presentation/screens/plan/overall/debts/debt_card.dart';
import 'package:saving_app/presentation/screens/style/styles.dart';
import 'package:saving_app/viewmodels/account/debt_viewmodel.dart';
import 'package:saving_app/viewmodels/plan_setting_viewmodel.dart';

class DebtsScreen extends ConsumerStatefulWidget {
  const DebtsScreen({super.key});

  @override
  ConsumerState<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends ConsumerState<DebtsScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final asyncDebts = ref.watch(debtsProvider);
    return Scaffold(
      appBar: defaultStyledAppBar(
        title: "Khoản nợ",
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: switch(asyncDebts) {
        AsyncData(:final value) => value.isEmpty
        ? const SizedBox.expand(
            child: Center(
              child: Column(
                children: [
                  Text("Bạn không có khoản nợ nào"),
                  Text("Nhưng nếu có hãy thêm để được hỗ trợ nha"),
                ],
              ),
            ),
          )
        : Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              const Text("Tổng nợ của bạn"),
              Consumer(
                builder: (context, ref, _) {
                  final totalDebt = ref.watch(totalDebtProvider);
                  return totalDebt.when(
                    data: (data) => Text(
                      "${NumberFormat.decimalPattern().format(data)} VND",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ), 
                    error: (error, stackTrace) => Text("$error"), 
                    loading: () => const CircularProgressIndicator(),
                  );
                }
              ),
              
              const SizedBox(height: 10,),
              const Text("Tiến trình tháng này"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    NumberFormat.decimalPattern().format(100000000),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    "/${NumberFormat.decimalPattern().format(100000000)} VND",
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const Expanded(
                    flex: 6,
                    child: Text("Chiến lược quản lý nợ")
                  ),
                  Expanded(
                    flex: 5,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Consumer(
                        builder: ((context, ref, child) {
                          final currentStrat = ref.watch(currentDebtStrategyProvider);
                          return DropdownMenu<DebtStrategy>(
                            inputDecorationTheme: InputDecorationTheme(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              constraints: const BoxConstraints(
                                maxHeight: 60,
                                minHeight: 0,
                                maxWidth: 150,
                                minWidth: 0
                              )
                            ),
                            initialSelection: currentStrat.when<DebtStrategy?>(
                              data: (data) => data, 
                              error: (error, _) => null, 
                              loading: () => null,
                            ),
                            dropdownMenuEntries: ref.read(debtStrategiesProvider)
                            .map((e) => DropdownMenuEntry(
                              value: e, 
                              label: e.title,
                            )).toList(),
                            onSelected: (value) {
                              if(value != null) {
                                ref.read(planSettingProvider).setDebtStrategy(value);
                              }
                            }
                          );
                        })
                      ),
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 7.0,
                children: ["Các khoản nợ", "Lộ trình","Biểu đồ cầu tuyết"].asMap().map(
                  (key, value) => MapEntry(key, ChoiceChip(
                    selectedColor: Colors.blue.shade300,
                    side: const BorderSide(width: 0.5),
                    backgroundColor: Colors.transparent,
                    label: Text(value),
                    selected: key == _selectedTab,
                    onSelected: (_) {
                      setState(() {
                        _selectedTab = key;
                      });
                    },
                  ))
                ).values.toList(),
              ),
              switch(_selectedTab){
                0 => _debtsList(value),
                1 => _schedule(),
                2 => _snowballChart(),
                _ => throw Exception("Invalid tab"),
              }
            ],
          ),
        ),
        AsyncError(:final error) => Center(
          child: Text("$error"),
        ),
        _ => const Center(
          child: CircularProgressIndicator(),
        )
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pushNewScreen(
            context, 
            screen: const NewAccountScreen(initType: AccountType.loan),
          );
        },
        child: const Icon(Icons.add_card),
      ),
    );
  }
  
  _debtsList(List<Debt> debts) {
    return Column(
      children: debts.map((e) => DebtCard(debt: e)).toList(),
    );
  }
  
  _snowballChart() {
    return const Placeholder();
  }
  
  _schedule() {
    return const Placeholder();
  }
  
  // List<DataEntry> _debtsToDataEntry(List<Debt> debts) {
  //   return debts.map((e) => DataEntry(
  //     totalDebt: e.amount!, 
  //     paidAmount: 0, 
  //     baseAmount: (e.amount! * 0.01).toInt(), 
  //     rate: 0.1, 
  //     interest: e.amount!)
  //   ).toList();
  // }
}
