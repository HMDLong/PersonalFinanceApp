import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/plan_transaction.model.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/data/local/model_repos/account/account_repo.dart';
import 'package:saving_app/presentation/screens/records/widgets/record_logs/event_picker.dart';
import 'package:saving_app/presentation/screens/shared_widgets/account_picker.dart';
import 'package:saving_app/presentation/screens/shared_widgets/category_picker.dart';
import 'package:saving_app/presentation/screens/shared_widgets/timestamp_picker.dart';
import 'package:saving_app/presentation/screens/style/styles.dart';
import 'package:saving_app/utils/randoms.dart';
import 'package:saving_app/viewmodels/transact/transact_viewmodel.dart';
import 'widgets/record_logs/transact_type_menu.dart';

class AddRecordScreen extends ConsumerStatefulWidget {
  const AddRecordScreen({super.key});

  @override
  ConsumerState<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends ConsumerState<AddRecordScreen>{
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};

  String? recordId;
  int? amount;
  TransactCategory? category;
  String? description;
  DateTime? timestamp;
  TransactionType? transactionType;
  Account? fromAccount;
  Account? toAccount;
  PlanTransaction? scheduledTransact;

  List<Map<String, dynamic>> _transactTypeMenuItems() =>
  [
    {
      "value": TransactionType.expense,
      "name": "Chi phí",
    },
    {
      "value": TransactionType.income,
      "name": "Thu nhập",
    },
    {
      "value": TransactionType.transact,
      "name": "Chuyển khoản",
    }
  ];

  void _onSubmit() {
    _formKey.currentState!.save();
    if(_formKey.currentState!.validate()){
      Transaction newTransaction = Transaction(
        id: getRandomKey(), 
        timestamp: timestamp!, 
        amount: amount! * switch(transactionType){
          TransactionType.expense => -1,
          TransactionType.income  => 1,
          _ => 1,
        },
        transactType: transactionType ?? TransactionType.expense,
        transactAccountId: fromAccount?.id,
        targetAccountId: toAccount?.id,
        categoryId: category!.id!,
        description: description,
        planTransactId: scheduledTransact?.id,
      );
      // context.read<TransactionProvider>().putTransaction(newTransaction);
      ref.watch(transactionsViewModelProvider).putTransaction(newTransaction);
      if(newTransaction.transactAccountId != null) {
        AccountManager.of(context).updateAccountBalance(newTransaction.transactAccountId!, newTransaction.amount);
      }
      if(newTransaction.targetAccountId != null) {
        AccountManager.of(context).updateAccountBalance(newTransaction.targetAccountId!, newTransaction.amount);
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Thêm thành công")));
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    timestamp = DateTime.now();
    transactionType = TransactionType.expense;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.back, color: Colors.black,),
        title: const Text(
          "Thông tin bản ghi",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(15.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            TransactionTypeMenu<TransactionType>(
              items: _transactTypeMenuItems(), 
              onTypeChanged: (newType) {
                setState(() {
                  transactionType = newType;
                });
              }
            ),
            const SizedBox(height: 10.0,),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: formFieldDecor(
                        icon: const Icon(CupertinoIcons.money_dollar),
                        label: const Text("Số tiền"),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return "Hãy nhập số tiền";
                        }
                        int parsedAmount = int.parse(value);
                        if (parsedAmount <= 0) {
                          return "Số tiền cần lớn hơn 0";
                        }
                        _formData["amount"] = parsedAmount;
                        return null;
                      },
                    ),
                  ),
                  TimestampPicker(
                    onTimeChange: (time) {
                      timestamp = time;
                    }
                  ),
                  CategoryPicker(
                    transactionType: transactionType!, 
                    onCategoryChanged: (value) {
                      category = value as TransactCategory;
                    },
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return "Hãy chọn";
                      }
                      return null;
                    },
                  ),
                  AccountPicker(
                    onAccountChanged: (Account value) { 
                      fromAccount = value;
                    },
                  ),
                  (
                    switch(transactionType) {
                      TransactionType.transact => AccountPicker(
                        onAccountChanged: (Account value) { 
                          toAccount = value;
                        },
                      ),
                      _ => const SizedBox(height: 5.0,),
                    }
                  ),
                  EventPicker(
                    onPicked: (PlanTransaction value) {
                      scheduledTransact = value;
                    },
                    type: transactionType!,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: formFieldDecor(
                        icon: const Icon(Icons.textsms_outlined),
                        label: const Text("Mô tả"),
                      ),
                      onSaved: (newValue) {
                        description = newValue;
                      },
                    ),
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
      persistentFooterButtons: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                child: const Text("Xác nhận"),
                onPressed: () {
                  _onSubmit();
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
