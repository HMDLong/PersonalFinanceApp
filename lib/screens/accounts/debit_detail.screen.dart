import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DebitDetailScreen extends StatefulWidget {
  const DebitDetailScreen({super.key});

  @override
  State<DebitDetailScreen> createState() => _DebitDetailScreenState();
}

class _DebitDetailScreenState extends State<DebitDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.back, color: Colors.black,),
        title: const Text(
          "Debit Detail",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [

        ],
      ),
    );
  }
}