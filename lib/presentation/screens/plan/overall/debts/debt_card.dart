import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/presentation/screens/shared_widgets/progress_gauge.dart';

class DebtCard extends ConsumerStatefulWidget {
  final Debt debt;
  final bool snowballBoost;
  final int? boostAmount;
  const DebtCard({super.key, required this.debt, this.snowballBoost = false, this.boostAmount});

  @override
  ConsumerState<DebtCard> createState() => _DebtCardState();
}

class _DebtCardState extends ConsumerState<DebtCard> {
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
              Row(
                children: [
                  Expanded(
                    flex: 6,
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
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: widget.snowballBoost
                    ? Card(
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)
                      ),
                      elevation: 4,
                      child: const SizedBox(
                        height: 30,
                        width: 60,
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Boxicons.bxs_upvote, color: Colors.white, size: 16,),
                              SizedBox(width: 4,),
                              Text("Tập trung", style: TextStyle(color: Colors.white, fontSize: 12),)
                            ],
                          ),
                        ),
                      ),
                    )
                    : const SizedBox(width: 0.1,)
                  ),
                ],
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
