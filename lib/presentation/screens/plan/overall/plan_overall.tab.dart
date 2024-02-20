import 'package:flutter/material.dart';
import 'package:saving_app/presentation/screens/plan/monthly_review/review_box.dart';
// import 'package:provider/provider.dart';
// import 'package:saving_app/presentation/managers/plan_manager.dart';
import 'package:saving_app/presentation/screens/plan/overall/budget/budget.dart';
import 'package:saving_app/presentation/screens/plan/overall/debts/debt.dart';
import 'package:saving_app/presentation/screens/plan/overall/expenses/expense.dart';
import 'package:saving_app/presentation/screens/plan/overall/general/overall.dart';
import 'package:saving_app/presentation/screens/plan/overall/incomes/incomes.dart';
import 'package:saving_app/presentation/screens/plan/overall/savings/saving.dart';

class PlanOverallTab extends StatefulWidget {
  const PlanOverallTab({super.key});

  @override
  State<PlanOverallTab> createState() => _PlanOverallTabState();
}

class _PlanOverallTabState extends State<PlanOverallTab> {

  @override
  Widget build(BuildContext context) {
    // final controller = context.read<PlanController>();
    final reviewTime = true;
    return SingleChildScrollView(
      child: Container(
        color: Colors.pink.shade50,
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            reviewTime ? const ReviewBox() : const SizedBox(height: 0.1,),
            const OverallSection(),
            const IncomesSection(),
            const ExpenseSection(),
            const SavingSection(),
            const BudgetSection(),
            const DebtSection(),
          ],
        ),
      ),
    );
  }
}
