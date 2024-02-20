import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:saving_app/presentation/screens/plan/overall/debts/debts.screen.dart';
import 'package:saving_app/presentation/screens/shared_widgets/progress_gauge.dart';
import 'package:saving_app/utils/times.dart';
import 'package:saving_app/viewmodels/account/debt_viewmodel.dart';

class DebtSection extends ConsumerStatefulWidget {
  const DebtSection({super.key});

  @override
  ConsumerState<DebtSection> createState() => _DebtSectionState();
}

class _DebtSectionState extends ConsumerState<DebtSection> {
  @override
  Widget build(BuildContext context) {
    final numberFormatter = NumberFormat.decimalPattern();
    return GestureDetector(
      onTap: () {
        pushNewScreen(context, screen: const DebtsScreen());
      },
      child: Consumer(
        builder: (context, ref, _) {
          final totalDebtFuture = ref.watch(totalDebtProvider);
          return totalDebtFuture.when(
            data: (totalDebt) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text(
                          "Khoản nợ",
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
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    const Text("Tổng dư nợ"),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                      child: Text(
                        "${numberFormatter.format(totalDebt)} VND",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Text("Tiến trình tháng"),
                    const SizedBox(height: 4,),
                    Consumer(
                      builder: (context, ref, child) {
                        final totalDebtPaidThisMonth = ref.watch(totalDebtPaidProvider(getRangeOfTheMonth()));
                        final totalDebtToPayThisMonth = ref.watch(totalDebtToPay(getRangeOfTheMonth())).when(
                          data: (data) => data, 
                          error: (error, _) => throw error, 
                          loading: () => 0
                        );
                        return LinearProgressGauge(
                          value: totalDebtPaidThisMonth.abs(),
                          max: totalDebtToPayThisMonth.abs(),
                          leadingLabel: "Đã trả",
                          trailingLabel: "Còn lại",
                          trailingValue: max<int>(totalDebtToPayThisMonth.abs() - totalDebtPaidThisMonth.abs(), 0),
                          mode: GaugeMode.goodOverflow,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            error: (error, _) => Text("$error"),
            loading: () => const CircularProgressIndicator(),
          );
        }
      )
    );
  }
}
