import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../records/widgets/transact_type_menu.dart';
import 'widgets/form/credit_form.dart';
import 'widgets/form/debit_form.dart';
import 'widgets/form/loan_form.dart';
import 'widgets/form/saving_form.dart';

class NewAccountScreen extends StatefulWidget{
  const NewAccountScreen({super.key});

  @override
  State<NewAccountScreen> createState() => _NewAccountScreenState();
}

enum AccountType {
  loan,
  debit,
  credit,
  saving,
}

class _NewAccountScreenState extends State<NewAccountScreen> {
  AccountType newAccountType = AccountType.debit;

  List<Map<String, dynamic>> _transactTypeMenuItems() =>
  [
    {
      "value": AccountType.debit,
      "name": "Debit",
    },
    {
      "value": AccountType.credit,
      "name": "Credit",
    },
    {
      "value": AccountType.saving,
      "name": "Saving",
    },
    {
      "value": AccountType.loan,
      "name": "Debt",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {

          },
          icon: const Icon(
            CupertinoIcons.back, 
            color: Colors.black,
          )
        ),
        title: const Text(
          "New Account",
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
          ),
          (switch(newAccountType){
            AccountType.credit => const NewCreditForm(),
            AccountType.debit => const NewDebitForm(),
            AccountType.loan => const NewLoanForm(),
            AccountType.saving => const NewSavingForm(),
          })
        ],
      ),
    );
  }
}

// styling
InputDecoration addRecordFormFieldStyle({Icon? icon}) =>
  InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
    prefixIcon: icon,
    fillColor: Colors.transparent,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: const BorderSide(),
    ),
  );
