import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/models/accounts.model.dart';
import 'package:saving_app/providers/local/model_providers/debit_repo.dart';
import 'package:saving_app/utils/randoms.dart';

class AddDebitScreen extends StatefulWidget {
  const AddDebitScreen({super.key});

  @override
  State<AddDebitScreen> createState() => _AddDebitScreenState();
}

class _AddDebitScreenState extends State<AddDebitScreen> {
  Debit newDebit = Debit(id: getRandomKey(), amount: 10000000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            var debitsRepo = context.read<DebitRepository>();
            debitsRepo.put(newDebit);
            Navigator.of(context).pop();
          },
        ),
        title: const Text("New Debit"),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Form"),
        ],
      ),
    );
  }
}