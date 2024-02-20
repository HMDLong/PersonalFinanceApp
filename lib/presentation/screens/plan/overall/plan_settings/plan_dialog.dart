import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/models/plan/income_dist.dart';
import 'package:saving_app/viewmodels/plan/plan_setting_viewmodel.dart';

class PlanDialog extends ConsumerStatefulWidget {
  const PlanDialog({super.key});

  @override
  ConsumerState<PlanDialog> createState() => _PlanDialogState();
}

class _PlanDialogState extends ConsumerState<PlanDialog> {
  int chosenPlan = 0;

  @override
  Widget build(BuildContext context) {
    final allPlans = ref.read(distsProvider);
    return AlertDialog(
      title: const Text("Hãy chọn 1 phương án"),
      content: ListView(
        shrinkWrap: true,
        children: List.generate(
          allPlans.length, 
          (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  chosenPlan = index;
                });
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(
                    color: chosenPlan == index ? Colors.blue.shade200 : Colors.white,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          allPlans[index].title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Text(
                        allPlans[index].shortExplaination,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        )
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(planSettingProvider).setIncomeDist(allPlans[chosenPlan]);
            Navigator.of(context).pop();
          }, 
          child: const Text("Xác nhận"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: const Text("Hủy"),
        ),
      ],
    );
  }
}
