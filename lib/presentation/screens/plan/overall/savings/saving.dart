import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:saving_app/presentation/screens/plan/overall/savings/savings.screen.dart';
import 'package:saving_app/presentation/screens/shared_widgets/progress_gauge.dart';

class SavingSection extends ConsumerStatefulWidget {
  const SavingSection ({super.key});

  @override
  ConsumerState<SavingSection> createState() => _SavingSectionState();
}

class _SavingSectionState extends ConsumerState<SavingSection > {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushNewScreen(context, screen: const SavingScreen());
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: const SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Tiết kiệm & Mục tiêu",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text("Chi tiết", style: TextStyle(color: Colors.blue),),
                      ),
                    )
                  ],
                ),
                Text("Tiến trình tháng"),
                SizedBox(height: 6,),
                LinearProgressGauge(
                  value: 100000,
                  max: 1000000,
                  leadingLabel: "Đã tiết kiệm",
                  trailingLabel: "Còn lại",
                  trailingValue: 1000000 - 100000,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}