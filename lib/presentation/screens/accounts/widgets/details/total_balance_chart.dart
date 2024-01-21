import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/presentation/screens/stats/widgets/balance_chart.dart';
import 'package:saving_app/utils/times.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AccountBalanceChart extends StatefulWidget {
  final ValueListenable<Box<Transaction>> boxListenable;
  final Account account;
  const AccountBalanceChart({super.key, required this.boxListenable, required this.account});

  @override
  State<AccountBalanceChart> createState() => _AccountBalanceChartState();
}

class _AccountBalanceChartState extends State<AccountBalanceChart> {
  TimeRange timeRange = getNDaysBefore(DateTime.now(), 30);

  List<DropdownMenuEntry<int>> _menuEntries() => [
    const DropdownMenuEntry(
      value: 30, 
      label: "30 ngày",
    ),
    const DropdownMenuEntry(
      value: 60, 
      label: "60 ngày",
    ),
    const DropdownMenuEntry(
      value: 90, 
      label: "90 ngày",
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Expanded(
                flex: 4,
                child: Text(
                  "Biến động số dư",
                  textAlign: TextAlign.start,
                ),
              ),
              Expanded(
                flex: 6,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: DropdownMenu<int>(
                    initialSelection: 30,
                    dropdownMenuEntries: _menuEntries(),
                    onSelected: (value) {
                      if(value != null) {
                        setState(() {
                          timeRange = getNDaysBefore(DateTime.now(), value);
                        });
                      }
                    },
                  ),
                )
              ),
            ],
          ),
        ),
        ValueListenableBuilder(
          valueListenable: widget.boxListenable,
          builder: (BuildContext context, Box<Transaction> value, Widget? child) { 
            final seriesToDisplay = toChartSeries(filterTransaction(value.values.toList()));
            return SfCartesianChart(
              primaryXAxis: CategoryAxis(
                plotOffset: 10.0,
                labelPlacement: LabelPlacement.onTicks,
                labelAlignment: LabelAlignment.center
              ),
              primaryYAxis: NumericAxis(
                numberFormat: NumberFormat.compact(),
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              zoomPanBehavior: ZoomPanBehavior(
                enablePinching: true,
                enablePanning: true,
                zoomMode: ZoomMode.x,
              ),
              series: <LineSeries<ChartData<DateTime, int>, String>>[
                LineSeries<ChartData<DateTime, int>, String>(
                  dataSource: seriesToDisplay,
                  xValueMapper: (ChartData<DateTime, int> data, _) => DateFormat.MMMd().format(data.x),
                  yValueMapper: (ChartData<DateTime, int> data, _) => data.y,
                  markerSettings: const MarkerSettings(isVisible: true),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
  
  List<ChartData<DateTime, int>> toChartSeries(List<Transaction> filterTransaction) {
    final groupByDateData = filterTransaction
    .fold(
      <DateTime, List<Transaction>>{}, 
      (previousValue, element) {
        final dateOnly = element.timestamp.toDateOnly();
        previousValue.putIfAbsent(dateOnly, () => []);
        previousValue[dateOnly]?.add(element);
        return previousValue;
      }
    );
    if(groupByDateData.keys.length < timeRange.duration){
      final rangeDates = timeRange.getRangeDates();
      for(var date in rangeDates) {
        if(!groupByDateData.containsKey(date)){
          groupByDateData[date] = [];
        }
      }
    }
    final chartData = groupByDateData.entries.map((e) => ChartData<DateTime, int>(
      x: e.key,
      y: e.value.isEmpty
         ? 0
         : e.value
           .map((transaction) => transaction.amount)
           .reduce((value, element) => value + element),
    )).toList();
    chartData.sort((a, b) {
        if(a.x.isAfter(b.x)) return -1;
        if(a.x.isBefore(b.x)) return 1;
        return 0;
      }
    );
    return chartData.fold(
      <ChartData<DateTime, int>>[ChartData(x: DateTime.now().toDateOnly(), y: widget.account.amount!)], 
      (previousValue, element) {
        final lastValue = previousValue.first;
        previousValue.insert(0, ChartData(
          x: element.x, 
          y: lastValue.y - element.y,
        ));
        return previousValue;
      }
    );
  }

  List<Transaction> filterTransaction(List<Transaction> transacts) {
    return transacts.where(
      (transact) {
        if(transact.transactAccountId != null && transact.transactAccountId == widget.account.id) return true;
        if(transact.targetAccountId != null && transact.targetAccountId == widget.account.id) return true;
        return false;
      }
    ).toList();
  }
}
