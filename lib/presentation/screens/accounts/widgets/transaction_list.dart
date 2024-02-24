import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/features/records/views/widgets/record_logs/transaction_card.dart';

class TransactionList extends StatelessWidget {
  final Box<Transaction> transactionBox;
  final Account account;
  const TransactionList({super.key, required this.transactionBox, required this.account});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: transactionBox.listenable(), 
      builder: (context, box, _ ) {
        final transactions = box.values.where(
          (transact) => transact.transactAccountId == account.id
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
    );
  }
}