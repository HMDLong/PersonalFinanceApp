import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/presentation/screens/plan/overall/plan_overall.tab.dart';
import 'package:saving_app/presentation/screens/plan/plan_calendar/plan_timeline.tab.dart';


class PlanScreen extends ConsumerStatefulWidget {
  const PlanScreen({super.key});

  @override
  ConsumerState<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends ConsumerState<PlanScreen>{

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Kế hoạch", 
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(child: Text("Tổng quan"),),
              Tab(child: Text("Lịch trình"),),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PlanOverallTab(),
            PlanTimelineTab(),
          ],
        ),
      ),
    );
  }
}
