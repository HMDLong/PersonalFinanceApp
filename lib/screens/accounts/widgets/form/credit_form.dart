import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/models/accounts.model.dart';
import 'package:saving_app/providers/local/model_providers/credit_repo.dart';
import 'package:saving_app/screens/style/styles.dart';
import 'package:saving_app/utils/randoms.dart';

import 'infull_form.dart';
import 'installment_form.dart';

class NewCreditForm extends StatefulWidget {
  const NewCreditForm({super.key});

  @override
  State<NewCreditForm> createState() => _NewCreditFormState();
}

class _NewCreditFormState extends State<NewCreditForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};
  var _paymentType = PaymentType.infull;
    
  void _onSubmit() {
    _formKey.currentState!.save();
    if(_formKey.currentState!.validate()){
      var repo = context.read<CreditRepository>();
      final newCredit = Credit(
        id: getRandomKey(),
        title: _formData["title"],
        amount: (_formData["amount"] ?? 0) * -1,
        payment: switch(_paymentType) {
          PaymentType.infull => Infull(
            duedate: _formData["duedate"],
            lateInterest: _formData["interest"],
          ),
          PaymentType.installment => Installment(
            period: _formData["period"],
            phase: _formData["phase"],
            originInterest: _formData["interest"],
            phaselyDuedate: _formData["duedate"],
          ),
        }, 
        limit: null
      );
      repo.put(newCredit);
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
            inputLabelWithPadding("Title"),
            TextFormField(
              decoration: addRecordFormFieldStyle(icon: const Icon(Icons.title)),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autofocus: true,
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return "Please add a title";
                }
                return null;
              },
              onFieldSubmitted: (value) {
                _formData["title"] = value;
              },
              onSaved: (newValue) {
                _formData["title"] = newValue;
              },
            ),
            inputLabelWithPadding("Amount"),
            TextFormField(
              initialValue: "0",
              decoration: addRecordFormFieldStyle(icon: const Icon(CupertinoIcons.money_dollar)),
              keyboardType: TextInputType.number,
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return "Please input amount";
                }
                try {
                  int parsedAmount = int.parse(value);
                  if (parsedAmount < 0) {
                    return "Amount should be positive";
                  }
                } catch(e) {
                  return "Amount should be integer";
                }
                return null;
              },
              onSaved: (newValue) {
                _formData["amount"] = int.parse(newValue!);
              },
              onFieldSubmitted: (value) {
                try {
                  _formData["amount"] = int.parse(value);
                } catch(e) {
                  //
                }
              },
            ),
            const SizedBox(height: 10.0,),
            Row(
              children: [
                const SizedBox(width: 10, height: 20,),
                const Text(
                  "Payment type",
                  style: TextStyle(fontSize: 14.0),
                ),
                const SizedBox(width: 10.0,),
                Radio<PaymentType>(
                  value: PaymentType.installment, 
                  groupValue: _paymentType, 
                  onChanged: (paymentType) {
                    if(paymentType != null) {
                      setState(() {
                        _paymentType = paymentType;
                      });
                    }
                  }
                ),
                const Text(
                  "Installment",
                  style: TextStyle(fontSize: 14.0),
                ),
                const SizedBox(width: 10.0,),
                Radio<PaymentType>(
                  value: PaymentType.infull, 
                  groupValue: _paymentType, 
                  onChanged: (paymentType) {
                    if(paymentType != null) {
                      setState(() {
                        _paymentType = paymentType;
                      });
                    }
                  }
                ),
                const Text(
                  "Infull",
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
            (switch(_paymentType){
              PaymentType.infull => InfullForm(formData: _formData,),
              PaymentType.installment => InstallmentForm(formData: _formData,),
            }),
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
