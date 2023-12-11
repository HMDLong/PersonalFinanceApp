import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditTransactionScreen extends StatelessWidget{
  const EditTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.back, color: Colors.black,),
        title: const Text(
          "Edit Transaction",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: const Column(
        children: [
          Text("abc"),
        ],
      ),
    );
  }
}