import 'package:flutter/material.dart';

class OverallSection extends StatefulWidget {
  const OverallSection({super.key});

  @override
  State<OverallSection> createState() => _OverallSectionState();
}

class _OverallSectionState extends State<OverallSection> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(),
          Row(),
          Row(),
        ],  
      ),
    );
  }
}