import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:saving_app/constants/constants.dart';
import 'package:saving_app/models/category.model.dart';
import 'package:saving_app/screens/style/styles.dart';
import 'package:saving_app/screens/records/widgets/category_bottom_sheet.dart';
import 'package:saving_app/utils/randoms.dart';
import '../../models/transaction.model.dart';
import 'widgets/transact_type_menu.dart';

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen>{
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};
  final TextEditingController _datePickerController = TextEditingController(
    text: DateFormat.yMMMMd().add_jm().format(DateTime.now())
  );
  final TextEditingController _categoryController = TextEditingController();
  TransactionType transactionType = TransactionType.expense;

  List<Map<String, dynamic>> _transactTypeMenuItems() =>
  [
    {
      "value": TransactionType.expense,
      "name": "Expense",
    },
    {
      "value": TransactionType.income,
      "name": "Income",
    },
    {
      "value": TransactionType.transact,
      "name": "Transact",
    }
  ];

  void _onSubmit() async {
    if(_formKey.currentState!.validate()){
      _formKey.currentState?.save();
      Transaction newTransaction = Transaction(
        id: getRandomKey(), 
        timestamp: _formData["date"] ?? DateTime.now(), 
        amount: _formData["amount"] * switch(transactionType){
          TransactionType.expense => -1,
          TransactionType.income  => 1,
          _ => 1,
        },
        transactAccountId: "",
        categoryId: (_formData["category"] as TransactCategory).id,
        description: _formData["des"],
      );
      await Hive.box<Transaction>(transactionBoxName).put(newTransaction.id, newTransaction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.back, color: Colors.black,),
        title: const Text(
          "Add new record",
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
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                    child: Text(
                      "Amount",
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    autofocus: true,
                    decoration: addRecordFormFieldStyle(icon: const Icon(CupertinoIcons.money_dollar)),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return "Please input amount";
                      }
                      int parsedAmount = int.parse(value);
                      if (parsedAmount <= 0) {
                        return "Amount should be greater than 0";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _formData["amount"] = int.parse(newValue!);
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                    child: Text(
                      "Date",
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                  TextFormField(
                    controller: _datePickerController,
                    autofocus: true,
                    readOnly: true,
                    decoration: addRecordFormFieldStyle(icon: const Icon(CupertinoIcons.calendar)),
                    onTap: _selectDate,
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 15.0, 0.0, 5.0),
                    child: Text(
                      "Category",
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                  TextFormField(
                    controller: _categoryController,
                    autofocus: true,
                    readOnly: true,
                    decoration: addRecordFormFieldStyle(icon: const Icon(CupertinoIcons.circle_grid_hex)),
                    onTap: _selectCategory,
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 15.0, 0.0, 5.0),
                    child: Text(
                      "Description",
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
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
            const SizedBox(height: 100.0,),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: const Text("Submit"),
                    onPressed: () {
                      _onSubmit();
                      Navigator.of(context).pop();
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
        return CategoryBottomSheet(
          type: transactionType == TransactionType.income,
        );
      }
    );

    if(pickedCategory != null) {
      setState(() {
        _formData["category"] = pickedCategory;
        _categoryController.text = pickedCategory.name;
      });
    }
  }
}
