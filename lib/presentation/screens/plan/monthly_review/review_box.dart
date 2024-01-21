import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:saving_app/presentation/screens/plan/monthly_review/review_screen.dart';

class ReviewBox extends ConsumerWidget {
  const ReviewBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        pushNewScreen(context, screen: const ReviewScreen());
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: CupertinoColors.activeBlue,
        elevation: 8,
        child: const SizedBox(
          height: 65,
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.reviews_sharp, color: Colors.white,)
                ),
              ),
              Expanded(
                flex: 8,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hôm nay đã là cuối tháng rồi",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12
                        ),
                      ),
                      Text(
                        "Hãy cùng đánh giá lại tháng vừa qua nào!",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12
                        ),
                      ),
                      SizedBox(height: 4,),
                      Text(
                        "Tới đánh giá",
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          fontSize: 12
                        ),
                      ),
                    ],
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}