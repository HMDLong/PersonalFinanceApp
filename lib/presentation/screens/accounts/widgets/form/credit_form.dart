import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/data/local/model_repos/account/credit_repo.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/plan_transaction.model.dart';
import 'package:saving_app/presentation/managers/plan_manager.dart';
import 'package:saving_app/presentation/screens/style/styles.dart';
import 'package:saving_app/utils/randoms.dart';
import 'infull_form.dart';
import 'installment_form.dart';

class NewCreditForm extends StatefulWidget {
  final Credit? prefill;
  const NewCreditForm({super.key, this.prefill});

  @override
  State<NewCreditForm> createState() => _NewCreditFormState();
}

class _NewCreditFormState extends State<NewCreditForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};
  var _paymentType = PaymentType.infull;

  String? numericValidator(String? value, String formKey) {
    if(value == null || value.isEmpty) {
      return "Hãy nhập số tiền";
    }
    final parsedAmount = int.tryParse(value);
    if(parsedAmount == null) {
      return "Cần là số";
    }
    if (parsedAmount < 0) {
      return "Số tiền cần lớn hơn 0";
    }
    _formData[formKey] = parsedAmount;
    return null;
  }
    
  void _onSubmit() {
    _formKey.currentState!.save();
    if(_formKey.currentState!.validate()){
      var repo = context.read<CreditRepository>();
      final newCredit = Credit(
        id: getRandomKey(),
        title: _formData["title"],
        amount: (_formData["amount"] ?? 0) * -1,
        limit: (_formData["limit"]) * -1,
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
      );
      repo.put(newCredit);
      context.read<PlanController>().newPlanTransaction(PlanTransaction(
        id: getRandomKey(), 
        title: "Trả nợ tín dụng ${_formData['title']}", 
        amount: (_formData["limit"] ?? 0) * -1, 
        categoryId: "c12.1",
        transactType: TransactionType.transact,
        transactDate: _formData["duedate"],
        period: Periodic.monthly,
        notificationId: _formData["isNotified"] ? Random().nextInt(1000000000) : -1, 
        targetAccount: newCredit.id!,
      ));
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    _formData["isNotified"] = true;
    super.initState();
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
            inputLabelWithPadding("Tiêu đề"),
            TextFormField(
              decoration: addRecordFormFieldStyle(icon: const Icon(Icons.title)),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return "Hãy nhập tiêu đề";
                }
                _formData["title"] = value;
                return null;
              },
            ),
            inputLabelWithPadding("Số tiền đã chi hiện tại"),
            TextFormField(
              initialValue: "0",
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: addRecordFormFieldStyle(icon: const Icon(CupertinoIcons.money_dollar)),
              keyboardType: TextInputType.number,
              validator: (value) => numericValidator(value, "amount"),
            ),
            inputLabelWithPadding("Mức hạn định"),
            TextFormField(
              initialValue: "0",
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: addRecordFormFieldStyle(icon: const Icon(CupertinoIcons.money_dollar)),
              keyboardType: TextInputType.number,
              validator: (value) => numericValidator(value, "limit"),
            ),
            const SizedBox(height: 10.0,),
            Row(
              children: [
                const SizedBox(width: 10, height: 20,),
                const Text(
                  "Loại hình chi trả",
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
                  "Trả góp",
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
                  "Trả đủ",
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
            (switch(_paymentType){
              PaymentType.infull => InfullForm(onDataChanged: (duedate, interest){
                if(duedate != null) _formData["duedate"] = duedate;
                if(interest != null) _formData["interest"] = interest;
              }),
              PaymentType.installment => InstallmentForm(
                formData: _formData,
                onDataChanged: (period, phase, duedate, interest) {
                  if(duedate != null) _formData["duedate"] = duedate;
                  if(interest != null) _formData["interest"] = interest;
                  if(phase != null)_formData["phase"] = phase;
                  if(period != null) _formData["period"] = period;
                }
              ),
            }),
            Row(
              children: [
                const Expanded(
                  flex: 8,
                  child: Text("Nhắc tôi khi đến ngày thực hiện"),
                ),
                Expanded(
                  flex: 2,
                  child: Switch(
                    value: _formData["isNotified"],
                    onChanged: (value) {
                      _formData["isNotified"] = value;
                    },
                  ),
                )
              ],
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: ElevatedButton(
                child: const Text("Xác nhận"),
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
