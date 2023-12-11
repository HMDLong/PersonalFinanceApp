import 'package:flutter/cupertino.dart';

class PatternTab extends StatefulWidget {
  const PatternTab({super.key});

  @override
  State<PatternTab> createState() => _PatternTabState();
}

class _PatternTabState extends State<PatternTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text("pattern")
        ],
      ),
    );
  }
}