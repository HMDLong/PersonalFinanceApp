import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:saving_app/constants/constants.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/presentation/screens/stats/widgets/balance_chart.dart';

class OverallTab extends StatefulWidget {
  const OverallTab({super.key});

  @override
  State<OverallTab> createState() => _OverallTabState();
}

class _OverallTabState extends State<OverallTab> {
  late Box<Transaction> _transactionBox;

  @override
  void initState() {
    super.initState();
    _transactionBox = Hive.box<Transaction>(transactionBoxName);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        BalanceChart(boxListenable: _transactionBox.listenable()),
      ],
    );
  }
}
