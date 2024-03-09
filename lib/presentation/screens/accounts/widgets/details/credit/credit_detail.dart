import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:saving_app/constants/constants.dart';
import 'package:saving_app/data/local/model_repos/account/account_repo.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/features/records/views/widgets/record_logs/transaction_card.dart';
import 'package:saving_app/presentation/screens/accounts/widgets/details/debit/edit_account.dart';
import 'package:saving_app/presentation/screens/accounts/widgets/details/total_balance_chart.dart';

class CreditDetail extends StatefulWidget {
  final Credit credit;
  const CreditDetail({super.key, required this.credit});

  @override
  State<CreditDetail> createState() => _CreditDetailState();
}

class _CreditDetailState extends State<CreditDetail> {
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
            onPressed: _editCredit, 
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
                      child: Text("Xóa ${widget.credit.title}?"),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        AccountManager.of(context).deleteAccount(widget.credit.id!);
                        Navigator.of(context).pop();
                      },
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
            icon: const Icon(Icons.delete, color: Colors.black,),
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
                  "${widget.credit.title}",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10,),
                const Text("Mức chi hiện tại"),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${NumberFormat.decimalPattern().format(widget.credit.amount)} VND",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      "/${NumberFormat.decimalPattern().format(widget.credit.limit)} VND",
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // AccountBalanceChart(
          //   boxListenable: transactionBox.listenable(), 
          //   account: widget.credit,
          //   height: 180,
          //   width: double.infinity
          // ),
          const SizedBox(height: 10,),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Giao dịch liên quan",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: transactionBox.listenable(), 
            builder: (context, box, _ ) {
              final transactions = box.values.where(
                (transact) => transact.transactAccountId == widget.credit.id
              );
              return transactions.isEmpty
              ? const Center(
                child: Text("Chưa có giao dịch nào"),
              )
              : Column(
                children: transactions.map(
                  (e) => TransactionCard(transaction: e)
                ).toList(),
              );
            }
          ),
        ],
      ),
    );
  }

  void _editCredit() {
    // pushNewScreen(context, screen: EditAccountScreen(account: widget.credit));
  }
}