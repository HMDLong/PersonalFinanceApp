import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/presentation/screens/plan/monthly_review/confirm_step.dart';
import 'package:saving_app/presentation/screens/plan/monthly_review/edit_step.dart';
import 'package:saving_app/presentation/screens/plan/monthly_review/review_step.dart';
import 'package:saving_app/presentation/screens/style/styles.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ReviewScreenState();
  }
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  int _currentStep = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultStyledAppBar(
        title: "Cập nhật kế hoạch",
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: Stepper(
        physics: const AlwaysScrollableScrollPhysics(),
        type: StepperType.horizontal,
        connectorThickness: 0.5,
        currentStep: _currentStep,
        steps: [
          Step(
            title: const Text("Đánh giá", style: TextStyle(fontSize: 12)), 
            content: const ReviewStep(), 
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text("Chỉnh sửa", style: TextStyle(fontSize: 12)), 
            content: const EditStep(),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text("Xác nhận", style: TextStyle(fontSize: 12)),
            content: const ConfirmStep(),
            isActive: _currentStep >= 2
          ),
        ],
        controlsBuilder: (context, details) {
          return Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CupertinoColors.activeBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: details.onStepCancel, 
                  child: const Text("Quay lại"),
                )
              ),
              const SizedBox(width: 20,),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CupertinoColors.activeBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                  onPressed: details.onStepContinue,
                  child: _currentStep == 2
                  ? const Text("Hoàn thành")
                  : const Text("Tiếp tục"),
                )
              ),
            ],
          );
        },
        onStepContinue: () {
          if(_currentStep != 2) {
            setState(() {
              _currentStep += 1;
            });
          }
        },
        onStepCancel: () {
          if(_currentStep != 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
      ),
    );
  }
}