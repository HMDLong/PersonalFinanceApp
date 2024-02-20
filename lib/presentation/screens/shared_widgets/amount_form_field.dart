import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saving_app/presentation/screens/style/styles.dart';

class AmountFormField extends StatefulWidget {
  const AmountFormField({super.key});

  @override
  State<AmountFormField> createState() => _AmountFormFieldState();
}

class _AmountFormFieldState extends State<AmountFormField> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _controller,
        decoration: formFieldDecor(
          icon: const Icon(CupertinoIcons.money_dollar),
          label: Text("Số tiền"),
        ),
      ),
    );
  }
}