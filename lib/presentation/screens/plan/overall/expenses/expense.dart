import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:saving_app/data/models/plan/income_dist.dart';
import 'package:saving_app/presentation/screens/plan/overall/expenses/expense.viewmodel.dart';
import 'package:saving_app/presentation/screens/plan/overall/plan_settings/plan_dialog.dart';
import 'package:saving_app/presentation/screens/plan/plan_transact/plan_transaction.tab.dart';
import 'package:saving_app/presentation/screens/stats/widgets/category_pie_chart.dart';
import 'package:saving_app/viewmodels/plan_setting_viewmodel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExpenseSection extends ConsumerStatefulWidget {
  const ExpenseSection({super.key});

  @override
  ConsumerState<ExpenseSection> createState() => _ExpenseSectionState();
}

class _ExpenseSectionState extends ConsumerState<ExpenseSection> {

  List<ChartData> _getChartData(Map distData) {
    return distData.map((key, value) {
      return MapEntry(key, ChartData(_getStringTitle(key), value[1]));
    }).values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "Khoản chi",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: const Text(
                        "Chi tiết",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        pushNewScreen(context, screen: const PlanTransactionTab.expense());
                      },
                    ),
                  ),
                )
              ],
            ),
            Consumer(
              builder: (context, ref, _) {
                final incomeDist = ref.watch(currentIncomeDistProvider).when(
                  data: (data) => data, 
                  error: (error, _) => null, 
                  loading: () => null
                );
                final distData = ref.watch(distMapProvider);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Phân bố thu nhập",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Text("${incomeDist?.title}"),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context, 
                              builder: (context) => const PlanDialog(),
                            );
                          }, 
                          icon: const Icon(Icons.edit_document)
                        )
                      ],
                    ),
                    Column(
                      children: distData.isEmpty
                      ? [
                          const SizedBox(
                            height: 100,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                "Hãy thiết lập khoản thu để được hỗ trợ nha",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                )
                              ),
                            )
                          ),
                        ]
                      : (distData as Map<ExpensesLevel, List<int>>).map<ExpensesLevel, Widget>((dataKey, value) {
                        return MapEntry(dataKey, Column(
                          children: [
                            const SizedBox(height: 10.0,),
                            Row(
                              children: [
                                Text(_getStringTitle(dataKey)),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        NumberFormat.decimalPattern().format(value[0]),
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "/${NumberFormat.decimalPattern().format(value[1])} VND",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54
                                        ),
                                      ),
                                    ],
                                  )
                                ),
                              ],
                            ),
                          ],
                        ));
                      }).values.toList()
                      + <Widget>[
                        const SizedBox(height: 8.0,),
                        SizedBox(
                          height: 250,
                          width: 250,
                          child: SfCircularChart(
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <DoughnutSeries<ChartData, String>>[
                              DoughnutSeries(
                                dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  overflowMode: OverflowMode.shift,
                                ),
                                dataLabelMapper: (data, index) => data.x,
                                enableTooltip: true,
                                dataSource: _getChartData(distData),
                                xValueMapper: (data, index) => data.x, 
                                yValueMapper: (data, index) => data.y
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
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