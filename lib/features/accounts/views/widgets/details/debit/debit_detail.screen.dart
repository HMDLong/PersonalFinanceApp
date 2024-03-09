import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:saving_app/constants/constants.dart';

import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/data/local/model_repos/account/account_repo.dart';
import 'package:saving_app/features/accounts/models/account.dart';
import 'package:saving_app/presentation/screens/accounts/widgets/details/debit/edit_account.dart';
import 'package:saving_app/presentation/screens/accounts/widgets/details/total_balance_chart.dart';
import 'package:saving_app/presentation/screens/accounts/widgets/transaction_list.dart';
import 'package:saving_app/presentation/screens/style/styles.dart';

class DebitDetailScreen extends StatefulWidget {
  final Account account;
  const DebitDetailScreen({super.key, required this.account});

  @override
  State<DebitDetailScreen> createState() => _DebitDetailScreenState();
}

class _DebitDetailScreenState extends State<DebitDetailScreen> {
  late Box<Transaction> transactionBox;

  @override
  void initState() {
    transactionBox = Hive.box<Transaction>(transactionBoxName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black,),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Chi tiết tài khoản",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _editDebit, 
            icon: const Icon(Boxicons.bx_edit, color: Colors.black),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context, 
                builder: (context) => AlertDialog(
                  content: SizedBox(
                    height: 40,
                    width: 100,
                    child: Center(
                      child: Text("Xóa ${widget.account.title}?"),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => AccountManager.of(context).deleteAccount(widget.account.id!),
                      child: const Text("Xác nhận"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Hủy"),
                    ),
                  ],
                ) 
              );
            }, 
            icon: const Icon(Icons.delete, color: Colors.black,)
          )
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.account.title}",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10,),
                const Text("Số dư hiện tại"),
                Text(
                  "${NumberFormat.decimalPattern().format(widget.account.amount)} VND",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
          AccountBalanceChart(
            boxListenable: transactionBox.listenable(), 
            account: widget.account,
            height: 180,
            width: double.infinity,
          ),
          inputLabelWithPadding("Giao dịch liên quan"),
          TransactionList(transactionBox: transactionBox, account: widget.account)
        ],
      ),
    );
  }

  void _editDebit() {
    pushNewScreen(context, screen: EditAccountScreen(account: widget.account));
  }
}