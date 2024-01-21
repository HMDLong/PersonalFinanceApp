import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/data/local/model_repos/account/credit_repo.dart';
import 'package:saving_app/data/local/model_repos/account/debit_repo.dart';
import 'package:saving_app/data/local/model_repos/account/savings_repo.dart';

class AccountBottomSheet extends StatefulWidget {
  const AccountBottomSheet({super.key});

  @override
  State<AccountBottomSheet> createState() => _AccountBottomSheetState();
}

class _AccountBottomSheetState extends State<AccountBottomSheet> {
  late List<bool> state;

  List<Widget> getAccountList() {
    final formatter = NumberFormat.decimalPattern();
    var debits = context.read<DebitRepository>().getAll();
    var savings = context.read<SavingRepository>().getAll();
    var credits = context.read<CreditRepository>().getAll();
    if(debits.isEmpty && savings.isEmpty && credits.isEmpty){
      return [
        const Center(
          child: Text("Chưa có tài khoản nào được lưu"),
        ),
      ];
    }
    return 
    debits.map((debit) => 
      GestureDetector(
        onTap: () => Navigator.of(context).pop(debit),
        child: ListTile(
          title: Text("${debit.title}"),
          subtitle: Text(" ${formatter.format(debit.amount)} VND"),
          trailing: const Text("Chi tiêu"),
        ),
      ),
    ).toList()
    + credits.map((credit) => 
      GestureDetector(
        onTap: () => Navigator.of(context).pop(credit),
        child: ListTile(
          title: Text("${credit.title}"),
          subtitle: Text("${formatter.format(credit.limit! - credit.amount!)} VND"),
          trailing: const Text("Tín dụng"),
        ),
      )
    ).toList()
    + savings.map((saving) => 
      GestureDetector(
        onTap: () => Navigator.of(context).pop(saving),
        child: ListTile(
          title: Text("${saving.title}"),
          subtitle: Text(" ${formatter.format(saving.amount)} VND"),
          trailing: const Text("Tiết kiệm"),
        ),
      )
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0), 
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 40,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0), 
                topRight: Radius.circular(10.0),
              ),
              color: Colors.blue,
            ),
            child: const Text(
              "Chọn tài khoản",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Expanded(
            child: ListView(
              children: getAccountList(),
            ),
          )
        ],
      ),
    );
  }
}