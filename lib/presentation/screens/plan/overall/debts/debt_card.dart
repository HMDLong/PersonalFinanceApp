import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/presentation/screens/shared_widgets/progress_gauge.dart';

class DebtCard extends StatefulWidget {
  final Debt debt;
  const DebtCard({super.key, required this.debt});

  @override
  State<DebtCard> createState() => _DebtCardState();
}

class _DebtCardState extends State<DebtCard> {
  @override
  Widget build(BuildContext context) {
    final formatDecimal = NumberFormat.decimalPattern().format;
    final paidAmount = 500000;
    final monthlyAmount = 1000000;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.debt.title}",
              ),
              Text(
                "${formatDecimal(widget.debt.amount)} VND",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
              const SizedBox(height: 10,),
              const Text("Tiến trình trả tháng này"),
              const SizedBox(height: 5,),
              LinearProgressGauge(
                leadingLabel: "Đã trả",
                trailingLabel: "Còn phải trả",
                value: paidAmount, 
                max: monthlyAmount,
              )
            ],
          ),
        ),
      ),
    );
  }
}
