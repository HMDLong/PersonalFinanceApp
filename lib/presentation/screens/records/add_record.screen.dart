import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/plan_transaction.model.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/data/local/model_repos/account/account_repo.dart';
import 'package:saving_app/presentation/screens/records/widgets/record_logs/event_picker.dart';
import 'package:saving_app/presentation/screens/shared_widgets/account_picker.dart';
import 'package:saving_app/presentation/screens/shared_widgets/category_picker.dart';
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
  final TextEditingController _datePickerController = TextEditingController(
    text: DateFormat.yMMMMd().add_jm().format(DateTime.now())
  );
  TransactionType transactionType = TransactionType.expense;

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
        timestamp: _formData["date"] ?? DateTime.now(), 
        amount: _formData["amount"] * switch(transactionType){
          TransactionType.expense => -1,
          TransactionType.income  => 1,
          _ => 1,
        },
        transactAccountId: _formData["sourceAcc"] != null ? (_formData["sourceAcc"] as Account).id : null,
        targetAccountId: _formData["targetAcc"] != null ? (_formData["targetAcc"] as Account).id : null,
        categoryId: (_formData["category"] as TransactCategory).id!,
        description: _formData["des"] as String,
        planTransactId: (_formData["event"] as PlanTransaction?)?.id,
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
  void dispose() {
    _datePickerController.dispose();
    super.dispose();
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
                  inputLabelWithPadding("Số tiền"),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: addRecordFormFieldStyle(icon: const Icon(CupertinoIcons.money_dollar)),
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
                  inputLabelWithPadding("Thời gian"),
                  TextFormField(
                    controller: _datePickerController,
                    readOnly: true,
                    decoration: addRecordFormFieldStyle(icon: const Icon(CupertinoIcons.calendar)),
                    onTap: _selectDate,
                  ),
                  CategoryPicker(
                    transactionType: transactionType, 
                    onCategoryChanged: (value) {
                      _formData["category"] = value;
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
                      _formData["sourceAcc"] = value;
                    },
                  ),
                  (
                    switch(transactionType) {
                      TransactionType.transact => AccountPicker(
                        onAccountChanged: (Account value) { 
                          _formData["targetAcc"] = value;
                        },
                      ),
                      _ => const SizedBox(height: 5.0,),
                    }
                  ),
                  EventPicker(
                    onPicked: (PlanTransaction value) {
                      _formData["event"] = value;
                    },
                    type: transactionType,
                  ),
                  inputLabelWithPadding("Mô tả"),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: addRecordFormFieldStyle(icon: const Icon(Icons.textsms_outlined)),
                    onSaved: (newValue) {
                      _formData["des"] = newValue;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0,),
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
        ),
      ),
    );
  }
  
  void _selectDate() async {
    DateTime currentDate = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context, 
      initialDate: currentDate, 
      firstDate: DateTime(currentDate.year - 1), 
      lastDate: DateTime(currentDate.year + 1),
    );

    if(pickedDate != null) {
      setState(() {
        _formData["date"] = pickedDate;
        _datePickerController.text = DateFormat.yMMMMd().add_jm().format(pickedDate);
      });
    }
  }
}
