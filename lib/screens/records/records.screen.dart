import 'package:flutter/material.dart';
// import 'package:saving_app/screens/styles.dart';
// import 'package:intl/intl.dart';

import 'widgets/budgets_carousel.dart';
import 'widgets/notification.dart';
import 'widgets/record_logs.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Records", 
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0,),
          children: const [
            NoticationBox(),
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                "Today's budgets",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            BudgetsCarousel(),
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                "Transactions",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            RecordLogs(),
          ],
        )
      ),
    );
  }
}
