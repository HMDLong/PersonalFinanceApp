import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:saving_app/constants/constants.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/presentation/screens/shared_widgets/timepicker_custom_dialog.dart';
import 'package:saving_app/presentation/screens/stats/widgets/category_pie_chart.dart';
import 'package:saving_app/utils/times.dart';

class PatternTab extends StatefulWidget {
  const PatternTab({super.key});

  @override
  State<PatternTab> createState() => _PatternTabState();
}

class _PatternTabState extends State<PatternTab> {
  late Box<Transaction> transactionBox;
  TimeRange timeRange = getRangeOfTheMonth();

  @override
  void initState() {
    transactionBox = Hive.box<Transaction>(transactionBoxName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CustomTimePicker(
          initialTimeType: TimeType.month,
          onTimeChanged: (newTimeRange) {
            setState(() {
              timeRange = newTimeRange;
            });
          },
          allowDay: false,
        ), 
        CategoryPieChart(
          transactionBox: transactionBox,
          timeRange: timeRange,
        ),
      ],
    );
  }
}

