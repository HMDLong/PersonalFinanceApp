import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saving_app/features/accounts/models/account.dart';
import 'package:saving_app/features/records/views/widgets/record_logs/transact_type_menu.dart';
import 'package:saving_app/presentation/screens/accounts/widgets/form/loan_form.dart';
import 'widgets/form/credit_form.dart';
import 'widgets/form/debit_form.dart';
import 'widgets/form/saving_form.dart';

class NewAccountScreen extends StatefulWidget{
  final AccountType? initType;
  const NewAccountScreen({super.key, this.initType});

  @override
  State<NewAccountScreen> createState() => _NewAccountScreenState();
}

class _NewAccountScreenState extends State<NewAccountScreen> {
  late AccountType newAccountType;

  List<Map<String, dynamic>> _transactTypeMenuItems() =>
  [
    {
      "value": AccountType.debit,
      "name": "Ghi nợ/Ví",
    },
    {
      "value": AccountType.credit,
      "name": "Tín dụng",
    },
    {
      "value": AccountType.saving,
      "name": "Tiết kiệm",
    },
    {
      "value": AccountType.debt,
      "name": "Khoản nợ",
    },
  ];

  @override
  void initState() {
    newAccountType = widget.initType ?? AccountType.debit;
    super.initState();
  }

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
      body: ListView(
        children: [
          TransactionTypeMenu<AccountType>(
            items: _transactTypeMenuItems(),
            onTypeChanged: (type) {
              setState(() {
                newAccountType = type;
              });
            },
            initType: newAccountType,
          ),
          (switch(newAccountType){
            AccountType.credit => const NewCreditForm(),
            AccountType.debit => const NewDebitForm(),
            AccountType.saving => const NewSavingForm(),
            AccountType.debt => const NewLoanForm(),
            _ => const SizedBox(),
          })
        ],
      ),
    );
  }
}
