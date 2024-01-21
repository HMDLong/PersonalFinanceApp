import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/presentation/screens/style/styles.dart';
import 'package:saving_app/utils/format.dart';

class ReviewStep extends ConsumerStatefulWidget {
  const ReviewStep({super.key});

  @override
  ConsumerState<ReviewStep> createState() => _ReviewStepState();
}

class _ReviewStepState extends ConsumerState<ReviewStep> {
  @override
  Widget build(BuildContext context) {
    final score = 90;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text("Tổng kết chi tiêu ${toVnMonthYear(DateTime.now())}"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${score}",
                      style: TextStyle(
                        fontSize: 26,
                        color: score < 50
                              ? Colors.red
                              : score < 80
                                ? Colors.amber.shade700
                                : Colors.green.shade600
                      ),
                    ),
                    const Text(
                      "/100",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54
                      ),
                    )
                  ],
                ),
              ],
            ),
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