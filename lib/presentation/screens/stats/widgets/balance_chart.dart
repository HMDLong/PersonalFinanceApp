import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/presentation/screens/shared_widgets/timepicker_custom_dialog.dart';
import 'package:saving_app/utils/times.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BalanceChart extends StatefulWidget {
  final ValueListenable<Box<Transaction>> boxListenable;
  const BalanceChart({super.key, required this.boxListenable});

  @override
  State<BalanceChart> createState() => _BalanceChartState();
}

class _BalanceChartState extends State<BalanceChart> {  
  final FilterSetting _filterSetting = FilterSetting(
    content: DisplayContent.expense,
    timeRange: getRangeOfTheMonth(),
    valueMode: DisplayValueMode.accumulate,
  );

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
    if(groupByDateData.keys.length < _filterSetting.timeRange.duration){
      final rangeDates = _filterSetting.timeRange.getRangeDates();
      // final tomorrow = DateTime.now().toDateOnly().add(const Duration(days: 1));
      for(var date in rangeDates) {
        if(!groupByDateData.containsKey(date)){
          groupByDateData[date] = [];
        }
      }
    }
    var chartData = groupByDateData.entries.map((e) => ChartData<DateTime, int>(
      x: e.key,
      y: e.value.isEmpty
         ? 0
         : e.value
           .map((transaction) => transaction.amount.abs())
           .reduce((value, element) => value + element),
    )).toList();
    chartData.sort((a, b) {
        if(a.x.isAfter(b.x)) return 1;
        if(a.x.isBefore(b.x)) return -1;
        return 0;
      }
    );
    // merge points
    if(chartData.length > 60) {
      final tmp = <ChartData<DateTime, int>>[];
      for(var month = 1; month <= 12; month++) {
        final daysInMonth = chartData.where((e) => e.x.month == month).toList();
        final monthAvg = daysInMonth.fold(0, (prev, e) => prev + e.y) / daysInMonth.length;
        tmp.add(ChartData(x: daysInMonth.first.x, y: monthAvg.toInt()));
      }
      chartData = tmp;
    }
    // accmulate tranformation
    if(_filterSetting.valueMode == DisplayValueMode.accumulate) {
      final accumulateChartData = <ChartData<DateTime, int>>[chartData.first];
      final tomorrow = DateTime.now().toDateOnly().add(const Duration(days: 1));
      for(var data in chartData.skip(1)) {
        accumulateChartData.add(ChartData<DateTime, int>(
          x: data.x,
          y: tomorrow.isAfter(data.x) ? accumulateChartData.last.y + data.y : 0,
        ));
      }
      return accumulateChartData;
    }
    return chartData;
  }
  
  List<Transaction> filterTransaction(Iterable<Transaction> values) {
    return values
    .where((transaction) => switch(_filterSetting.content) {
        DisplayContent.expense => transaction.amount < 0,
        DisplayContent.income => transaction.amount > 0,
        DisplayContent.balance => true,
      }
    )
    .where((transaction) => _filterSetting.timeRange.contain(transaction.timestamp))
    .toList();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().toDateOnly();
    return Column(
      children: [
        CustomTimePicker(
          initialTimeType: TimeType.month,
          onTimeChanged: (newTimeRange) {
            setState(() {
              _filterSetting.timeRange = newTimeRange;
            });
          },
          allowDay: false,
        ), 
        const Padding(
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 5.0, 5.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Biến động chỉ số",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Thu chi của tôi đã thay đổi như thế nào",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ValueListenableBuilder(
          valueListenable: widget.boxListenable,
          builder: (BuildContext context, Box<Transaction> value, Widget? child) { 
            final seriesToDisplay = toChartSeries(filterTransaction(value.values));
            return SfCartesianChart(
              primaryXAxis: CategoryAxis(
                plotOffset: 10.0,
                labelPlacement: LabelPlacement.onTicks,
                labelAlignment: LabelAlignment.center,
                // plotBands: [
                //   PlotBand(
                //     isVisible: true,
                //     start: DateFormat.MMMd().format(today),
                //     end: DateFormat.MMMd().format(today),
                //     text: "Today",
                //     textAngle: 360,
                //     borderWidth: 1,
                //     borderColor: Colors.black,
                //     dashArray: const <double>[4, 5],
                //     verticalTextAlignment: TextAnchor.start,
                //     shouldRenderAboveSeries: true,
                //     verticalTextPadding: "-4%"
                //   ),
                // ]
              ),
              primaryYAxis: NumericAxis(
                majorGridLines: const MajorGridLines(),
                numberFormat: NumberFormat.compact(),
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              zoomPanBehavior: ZoomPanBehavior(
                enablePinching: true,
                enablePanning: true,
                zoomMode: ZoomMode.x,
              ),
              series: <SplineSeries<ChartData<DateTime, int>, String>>[
                SplineSeries<ChartData<DateTime, int>, String>(
                  dataSource: seriesToDisplay,
                  xValueMapper: (ChartData<DateTime, int> data, _) => DateFormat.MMMd().format(data.x),
                  yValueMapper: (ChartData<DateTime, int> data, _) => data.y,
                  // markerSettings: const MarkerSettings(
                  //   isVisible: true,
                  //   height: 5,
                  //   width: 5,
                  // ),
                  // gradient: LinearGradient(
                  //   colors: [
                  //     Colors.blue.shade50,
                  //     Colors.blue.shade200,
                  //     Colors.blue,
                  //   ],
                  //   stops: const [0, 0.5, 1],
                  // ),
                  // borderColor: Colors.blue.shade600,
                  // borderWidth: 1,
                  color: switch(_filterSetting.content) {
                    DisplayContent.expense => Colors.red.shade300,
                    DisplayContent.income => Colors.green,
                    DisplayContent.balance => Colors.blue
                  },
                  // borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          child: Row(
            children: [
              const Text("Biểu đồ"),
              const SizedBox(width: 10,),
              DropdownButton<DisplayContent>(
                value: _filterSetting.content,
                // style: TextStyle(fontSize: 12, color: Colors.black),
                items: const [
                  DropdownMenuItem(
                    value: DisplayContent.balance,
                    child: Text("Số dư")
                  ),
                  DropdownMenuItem(
                    value: DisplayContent.expense,
                    child: Text("Chi phí")
                  ),
                  DropdownMenuItem(
                    value: DisplayContent.income,
                    child: Text("Thu nhập")
                  ),
                ], 
                onChanged: (value) {
                  if(value != null){
                    setState(() {
                      _filterSetting.content = value;
                    });
                  }
                }
              ),
              const SizedBox(width: 20,),
              const Text("Loại"),
              const SizedBox(width: 10,),
              DropdownButton<DisplayValueMode>(
                value: _filterSetting.valueMode,
                // style: TextStyle(fontSize: 12, color: Colors.black),
                items: const [
                  DropdownMenuItem(
                    value: DisplayValueMode.accumulate,
                    child: Text("Tích lũy")
                  ),
                  DropdownMenuItem(
                    value: DisplayValueMode.separated,
                    child: Text("Độc lập")
                  ),
                ], 
                onChanged: (value) {
                  if(value != null){
                    setState(() {
                      _filterSetting.valueMode = value;
                    });
                  }
                }
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FilterSetting {
  DisplayContent content;
  TimeRange timeRange;
  DisplayValueMode valueMode;

  FilterSetting({
    required this.content,
    required this.timeRange,
    this.valueMode = DisplayValueMode.accumulate,
  });
}

enum DisplayValueMode {
  separated,
  accumulate
}

enum DisplayContent {
  balance,
  expense,
  income,
}

class ChartData<T, R> {
  T x;
  R y;

  ChartData({
    required this.x,
    required this.y,
  });
}