import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/domain/providers/savings_provider.dart';
import 'package:saving_app/presentation/managers/transaction_manager.dart';
import 'package:saving_app/presentation/screens/accounts/new_account.screen.dart';
import 'package:saving_app/presentation/screens/shared_widgets/progress_gauge.dart';
import 'package:saving_app/presentation/screens/style/styles.dart';

class SavingScreen extends ConsumerStatefulWidget {
  const SavingScreen({super.key});

  @override
  ConsumerState<SavingScreen> createState() => _SavingScreenState();
}

class _SavingScreenState extends ConsumerState<SavingScreen> {
  @override
  Widget build(BuildContext context) {
    final asyncSavings = ref.watch(savingProvider);
    final thisMonthSaving = 5000000;
    final transactions = context.watch<TransactionProvider>().getByCategory("c12.3");
    return Scaffold(
      appBar: defaultStyledAppBar(
        title: "Tiết kiệm",
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: switch(asyncSavings){
        AsyncData(:final value) => 
        value.isEmpty
        ? const SizedBox.expand(
          child: Center(
            child: Column(
              children: [
                Text("Chưa có thông tin", style: TextStyle(color: Colors.black54)),
                Text("Thêm thông tin để được hỗ trợ theo dõi", style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        )
        : Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              const Text("Tổng tiết kiệm"),
              Text("${NumberFormat.decimalPattern().format(
                  value.fold(0, (prev, saving) => prev + saving.amount!)
                )} VND",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10,),
              const Text("Tiến trình tiết kiệm tháng này"),
              Row(
                children: [
                  Text(
                    NumberFormat.decimalPattern().format(
                      transactions.fold(0, (prev, e) => prev + e.amount)
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    "/${NumberFormat.decimalPattern().format(thisMonthSaving)} VND",
                    style: const TextStyle(
                      color: Colors.black54
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: value.map((e) {
                  return Card(
                    child: SizedBox(
                      // height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${e.title}"),
                          Text("${e.amount}"),
                          const Text("Tháng này"),
                          LinearProgressGauge(
                            value: 100000,
                            max: 1000000,
                            leadingLabel: "Đã tiết kiệm",
                            trailingLabel: "Mục tiêu tháng",
                            trailingValue: 1000000 - 100000,
                            labelFontSize: 14,
                          ),
                          e.goal != null
                          ? Column(
                            children: [
                              Text("Mục tiêu: ${e.goal?.title}"),
                              LinearProgressGauge(
                                value: 100000,
                                max: 1000000,
                                leadingLabel: "Đã tiết kiệm",
                                trailingLabel: "Mục tiêu tháng",
                                trailingValue: 1000000 - 100000,
                                labelFontSize: 14,
                              ),
                            ],
                          )
                          : SizedBox(height: 5,),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        AsyncError(:final error) => Text("$error"),
        _ => const Center(child: CircularProgressIndicator()),
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pushNewScreen(context, screen: const NewAccountScreen(initType: AccountType.saving));
        },
        child: const Icon(Boxicons.bx_coin_stack),
      ),
    );
  }
}