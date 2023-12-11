import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/models/accounts.model.dart';
import 'package:saving_app/providers/local/model_providers/debit_repo.dart';
import 'package:saving_app/screens/style/styles.dart';
import 'package:saving_app/utils/randoms.dart';

class NewDebitForm extends StatefulWidget {
  const NewDebitForm({super.key});

  @override
  State<NewDebitForm> createState() => _NewDebitFormState();
}

class _NewDebitFormState extends State<NewDebitForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};
    
  void _onSubmit() {
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      var repo = context.read<DebitRepository>();
      repo.put(
        Debit(id: getRandomKey(), amount: _formData["amount"] as int)
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
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
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: ElevatedButton(
                child: const Text("Submit"),
                onPressed: () {
                  _onSubmit();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}