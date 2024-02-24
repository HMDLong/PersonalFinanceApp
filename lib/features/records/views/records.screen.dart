import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:saving_app/features/records/views/add_record.screen.dart';
import 'package:saving_app/presentation/screens/style/styles.dart';
import 'widgets/record_logs/record_logs.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultStyledAppBar(
        title: "Nhật ký thu chi",
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: RecordLogs(),
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pushNewScreen(context, screen: const AddRecordScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
