import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:saving_app/presentation/screens/style/styles.dart';
import 'package:saving_app/utils/format.dart';
import 'package:saving_app/utils/times.dart';
import 'package:saving_app/viewmodels/transact/transact_viewmodel.dart';

class ReviewStep extends ConsumerStatefulWidget {
  const ReviewStep({super.key});

  @override
  ConsumerState<ReviewStep> createState() => _ReviewStepState();
}

class _ReviewStepState extends ConsumerState<ReviewStep> {
  @override
  Widget build(BuildContext context) {
    final totalExpense = ref.watch(totalActualExpenseProvider(getRangeOfTheMonth()));
    final totalIncome = ref.watch(totalActualIncomeProvider(getRangeOfTheMonth()));
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  "Tổng kết chi tiêu ${toVnMonthYear(DateTime.now())}",
                  style: const TextStyle(
                    fontSize: 18
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   children: [
                //     Text(
                //       "${score}",
                //       style: TextStyle(
                //         fontSize: 26,
                //         color: score < 50
                //               ? Colors.red
                //               : score < 80
                //                 ? Colors.amber.shade700
                //                 : Colors.green.shade600
                //       ),
                //     ),
                //     const Text(
                //       "/100",
                //       style: TextStyle(
                //         fontSize: 18,
                //         color: Colors.black54
                //       ),
                //     )
                //   ],
                // ),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          inputLabelWithPadding("Tổng quan"),
          const SizedBox(height: 6,),
          Row(
            children: [
              const Text("Tổng thu nhập"),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("${NumberFormat.decimalPattern().format(totalIncome)} VND"),
                )
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              const Text("Tổng chi phí"),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("${NumberFormat.decimalPattern().format(totalExpense)} VND"),
                )
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              const Text("Dòng tiền"),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${NumberFormat.decimalPattern().format(totalIncome + totalExpense)} VND",
                    style: TextStyle(
                      color: totalIncome + totalExpense > 0 ? Colors.green : Colors.red,
                    ),
                  ),
                )
              ),
            ],
          ),
          const SizedBox(height: 10,),
          inputLabelWithPadding("Mức sử dụng ngân quỹ"),
          
          inputLabelWithPadding("Thực hiện thu chi"),
          inputLabelWithPadding("Trả nợ"),
          inputLabelWithPadding("Tiết kiệm"),
        ],
      ),
    );
  }
}