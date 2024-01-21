import 'package:flutter/material.dart';
import 'package:saving_app/presentation/screens/stats/data_report.tab.dart';
import 'package:saving_app/presentation/screens/stats/pattern.tab.dart';

import 'overall.tab.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Thống kê", 
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
              Tab(child: Text("Xu hướng"),),
              Tab(child: Text("Báo cáo"),),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            OverallTab(),
            PatternTab(),
            DataTab(),
          ],
        ),
      ),
    );
  }
}