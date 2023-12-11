import 'package:flutter/cupertino.dart';

class CompareTab extends StatefulWidget {
  const CompareTab({super.key});

  @override
  State<CompareTab> createState() => _CompareTabState();
}

class _CompareTabState extends State<CompareTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('compare')
        ],
      ),
    );
  }
}