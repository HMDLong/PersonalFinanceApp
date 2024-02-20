import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:saving_app/constants/constants.dart';
import 'package:saving_app/data/local/model_repos/records/category_repository.dart';
import 'package:saving_app/data/local/model_repos/account/account_repo.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/presentation/screens/shared_widgets/account_bottom_sheet.dart';
import 'package:saving_app/presentation/screens/style/styles.dart';
import 'package:saving_app/presentation/screens/shared_widgets/category_bottom_sheet.dart';
import 'package:saving_app/utils/randoms.dart';
import 'widgets/record_logs/transact_type_menu.dart';

class TransactionInput extends StatefulWidget {
  final Transaction? transaction;
  final TransactionType? lockedTransaction;

  const TransactionInput({super.key, this.transaction, this.lockedTransaction});

  @override
  State<StatefulWidget> createState() => _TransactionInputState();
}

class _TransactionInputState extends State<TransactionInput>{
  final _formKey = GlobalKey<FormState>();
  late final Map<String, dynamic> _formData;
  final TextEditingController _datePickerController = TextEditingController(
    text: DateFormat.yMMMMd().add_jm().format(DateTime.now())
  );
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _sourceAccController = TextEditingController();
  final TextEditingController _targetAccController = TextEditingController();
  late TransactionType transactionType = TransactionType.expense;

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
        id: _formData["id"] ?? getRandomKey(), 
        timestamp: _formData["date"] ?? DateTime.now(), 
        amount: _formData["amount"] * switch(transactionType){
          TransactionType.expense => -1,
          TransactionType.income  => 1,
          _ => 1,
        },
        transactType: _formData["transactType"],
        transactAccountId: _formData["sourceAcc"],
        targetAccountId: _formData["targetAcc"],
        categoryId: _formData["category"],
        description: _formData["des"],
      );
      Hive.box<Transaction>(transactionBoxName)
      .put(newTransaction.id, newTransaction)
      .then((_) => Navigator.of(context).pop());
    }
  }

  @override
  void initState() {
    super.initState();
    final transaction = widget.transaction;
    if(transaction != null) {
      _formData = {
        "id": transaction.id,
        "amount": transaction.amount,
        "date": transaction.timestamp,
        "sourceAcc": transaction.transactAccountId,
        "category": transaction.categoryId,
        "targetAcc": transaction.targetAccountId,
        "des": transaction.description,
        "transactType": transaction.transactType,
      };
      _categoryController.text = "${CategoryRepository().getAt(transaction.categoryId)!.name}";
      Future.delayed(Duration.zero, () {
        if(transaction.transactAccountId != null) {
          _sourceAccController.text = AccountManager.of(context).getAccountById(transaction.transactAccountId!)?.title as String;
        }
        if(transaction.targetAccountId != null) {
          _sourceAccController.text = AccountManager.of(context).getAccountById(transaction.targetAccountId!)?.title as String;
        }
      });
      _datePickerController.text = transaction.timestamp.toString();
    } else {
      _formData = {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.back, color: Colors.black,),
        title: const Text(
          "Sửa thông tin",
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
                    initialValue: "${(_formData["amount"] as int).abs()}",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: formFieldDecor(icon: const Icon(CupertinoIcons.money_dollar)),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return "Hãy nhập số tiền";
                      }
                      int parsedAmount = int.parse(value);
                      if (parsedAmount <= 0) {
                        return "Số tiền cần lớn hơn 0";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _formData["amount"] = int.parse(newValue!);
                    },
                  ),
                  inputLabelWithPadding("Thời gian"),
                  TextFormField(
                    controller: _datePickerController,
                    readOnly: true,
                    decoration: formFieldDecor(icon: const Icon(CupertinoIcons.calendar)),
                    onTap: _selectDate,
                  ),
                  inputLabelWithPadding("Loại"),
                  TextFormField(
                    controller: _categoryController,
                    readOnly: true,
                    decoration: formFieldDecor(icon: const Icon(CupertinoIcons.circle_grid_hex)),
                    onTap: _selectCategory,
                  ),
                  inputLabelWithPadding("Tài khoản nguồn"),
                  TextFormField(
                    controller: _sourceAccController,
                    readOnly: true,
                    decoration: formFieldDecor(icon: const Icon(Boxicons.bx_wallet)),
                    onTap: () => _selectAccount(_sourceAccController, "sourceAcc"),
                  ),
                  (
                    switch(transactionType) {
                      TransactionType.transact => 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            inputLabelWithPadding("Tài khoản đích"),
                            TextFormField(
                              controller: _targetAccController,
                              readOnly: true,
                              decoration: formFieldDecor(icon: const Icon(CupertinoIcons.circle_grid_hex)),
                              onTap: () => _selectAccount(_targetAccController, "targetAcc"),
                            )
                          ]
                        ),
                      _ => const SizedBox(height: 5.0,),
                    }
                  ),
                  inputLabelWithPadding("Mô tả"),
                  TextFormField(
                    initialValue: _formData["des"],
                    keyboardType: TextInputType.text,
                    decoration: formFieldDecor(icon: const Icon(Icons.textsms_outlined)),
                    onSaved: (newValue) {
                      _formData["des"] = newValue;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100.0,),
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

  void _selectCategory() async {
    TransactCategory? pickedCategory = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0), 
        topRight: Radius.circular(10.0),
      )),
      builder: (context) {
        return CategoryBottomSheet(type: transactionType);
      }
    );

    if(pickedCategory != null) {
      setState(() {
        _formData["category"] = pickedCategory.id;
        _categoryController.text = "${pickedCategory.name}";
      });
    }
  }  

  void _selectAccount(TextEditingController controller, String fieldKey) async {
    Account? account = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0), 
        topRight: Radius.circular(10.0),
      )),
      builder: (context) {
        return const AccountBottomSheet();
      }
    );

    if(account != null) {
      setState(() {
        _formData[fieldKey] = account.id;
        controller.text = account.title!;
      });
    }
  }
}
