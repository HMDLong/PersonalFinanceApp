import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:saving_app/presentation/screens/plan/plan_transact/plan_transaction.tab.dart';
import 'package:saving_app/presentation/screens/shared_widgets/progress_gauge.dart';
import 'package:saving_app/utils/times.dart';
import 'package:saving_app/viewmodels/transact/plan_transact_viewmodel.dart';
import 'package:saving_app/viewmodels/transact/transact_viewmodel.dart';

class IncomesSection extends ConsumerStatefulWidget {
  const IncomesSection({super.key});

  @override
  ConsumerState<IncomesSection> createState() => _IncomesSectionState();
}

class _IncomesSectionState extends ConsumerState<IncomesSection> {
  @override
  Widget build(BuildContext context) {
    final expectedTotalIncome = ref.watch(totalExpectedIncomeProvider(getRangeOfTheMonth()));
    final actualCurrentIncome = ref.watch(totalActualIncomeProvider(getRangeOfTheMonth()));
    return GestureDetector(
      onTap: () {
        pushNewScreen(context, screen: const PlanTransactionTab.income());
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Row(
                children: [
                  Text(
                    "Nguồn thu",
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
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              // expectedTotalIncome.when(
              //   data: (data) => data > 0 ?
              expectedTotalIncome > 0 ?
                Column(
                  children: [
                    const Text("Thu nhập tháng này"),
                    LinearProgressGauge(
                      value: actualCurrentIncome, 
                      max: expectedTotalIncome,
                      leadingLabel: "Thực thu",
                      trailingLabel: "Dự kiến",
                      showOverflow: true,
                      mode: GaugeMode.goodOverflow,
                    )
                  ],
                )
                : const SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Chưa có thông tin",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12
                          ),
                        ),
                        Text(
                          "Hãy thêm để được hỗ trợ lập kế hoạch nha",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12
                          ),
                        ),
                      ]
                    ),
                  ),
              //   error: (error, stackTrace) => Text("$error"),
              //   loading: () => const Center(child: CircularProgressIndicator()),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
