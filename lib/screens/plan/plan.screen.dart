import 'package:flutter/material.dart';
import 'package:saving_app/screens/plan/budget/budgets.tab.dart';
import 'package:saving_app/screens/plan/overview/plan_overall.tab.dart';
import 'package:saving_app/screens/plan/plan_transact/plan_transaction.tab.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen>{
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
            isScrollable: true,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(child: Text("Tổng quan"),),
              Tab(child: Text("Khoản định sẵn"),),
              Tab(child: Text("Ngân sách"),),
            ]
          ),
        ),
        body: const TabBarView(
          children: [
            PlanOverviewTab(),
            PlanTransactionTab(),
            BudgetTab(),
          ],
        ),
      ),
    );
  }
}

