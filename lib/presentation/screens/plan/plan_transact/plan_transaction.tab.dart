import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:saving_app/presentation/screens/plan/plan_transact/expense.tab.dart';
import 'package:saving_app/presentation/screens/plan/plan_transact/income.tab.dart';
import 'package:saving_app/presentation/screens/plan/plan_transact/new_plan_transact.screen.dart';

class PlanTransactionTab extends StatefulWidget {
  final int? initTab;
  const PlanTransactionTab({super.key, this.initTab});

  const PlanTransactionTab.expense({super.key, this.initTab = 1});

  const PlanTransactionTab.income({super.key, this.initTab = 0});

  @override
  State<PlanTransactionTab> createState() => _PlanTransactionTabState();
}

class _PlanTransactionTabState extends State<PlanTransactionTab> {

  @override
  Widget build(BuildContext context) {
    // var transacts = context.watch<PlanTransactJsonRepository>().getAll();
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            "Kế hoạch thu chi",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black
            ),
          ),
          bottom: const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: "Thu nhập"),
              Tab(text: "Chi tiêu & Tiết kiệm"),
            ],
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.all(8.0),
          child: TabBarView(
            children: [
              IncomeTab(),
              ExpenseTab(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Boxicons.bx_calendar_plus),
          onPressed: () {
            pushNewScreen(context, screen: const NewPlanTransactScreen());
          }
        ),
      )
    );
  }
}
