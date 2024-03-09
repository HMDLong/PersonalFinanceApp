import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/presentation/screens/accounts/widgets/form/credit_form.dart';
import 'package:saving_app/presentation/screens/accounts/widgets/form/debit_form.dart';
import 'package:saving_app/presentation/screens/accounts/widgets/form/saving_form.dart';

class EditAccountScreen extends StatefulWidget {
  final Account account;
  const EditAccountScreen({super.key, required this.account});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            CupertinoIcons.back, 
            color: Colors.black,
          )
        ),
        title: const Text(
          "Thông tin tài khoản",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: widget.account is Debit
            ? NewDebitForm(prefill: widget.account as Debit)
            : widget.account is Credit
              ? NewCreditForm(prefill: widget.account as Credit)
              : NewSavingForm(prefill: widget.account as Saving)
    );
  }
}