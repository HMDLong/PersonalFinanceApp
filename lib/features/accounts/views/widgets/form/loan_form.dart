import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/plan_transaction.model.dart';
import 'package:saving_app/presentation/managers/plan_manager.dart';
import 'package:saving_app/presentation/screens/accounts/widgets/form/infull_form.dart';
import 'package:saving_app/presentation/screens/accounts/widgets/form/installment_form.dart';

import 'package:saving_app/presentation/screens/style/styles.dart';
import 'package:saving_app/utils/randoms.dart';
import 'package:saving_app/viewmodels/account/debt_viewmodel.dart';

class NewLoanForm extends ConsumerStatefulWidget {
  const NewLoanForm({super.key});

  @override
  ConsumerState<NewLoanForm> createState() => _NewLoanFormState();
}

class _NewLoanFormState extends ConsumerState<NewLoanForm> {
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
      // var repo = context.read<DebtsRepositoryLocalImpl>();
      final newDebt = Debt(
        id: getRandomKey(),
        title: _formData["title"],
        amount: (_formData["amount"] ?? 0) * -1,
        payment: switch(_paymentType) {
          PaymentType.infull => Infull(
            duedate: _formData["duedate"],
            lateInterest: _formData["interest"],
            minPayment: (_formData["amount"] ?? 0) * -1
          ),
          PaymentType.installment => Installment(
            minPayment: _formData["min_payment"],
            period: _formData["period"],
            originInterest: _formData["interest"],
            phaselyDuedate: _formData["duedate"],
          ),
        }, 
      );
      ref.read(debtViewModelProvider).putDebt(newDebt);
      context.read<PlanController>().newPlanTransaction(PlanTransaction(
        id: getRandomKey(), 
        title: "Trả nợ ${_formData['title']}", 
        amount: (_formData["amount"] ?? 0) * -1, 
        categoryId: "c12.3",
        transactDate: _formData["duedate"],
        period: Periodic.monthly,
        notificationId: _formData["isNotified"] ? Random().nextInt(1000000) : -1, 
        transactType: TransactionType.transact,
        targetAccount: newDebt.id!,
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
              decoration: formFieldDecor(icon: const Icon(Icons.title)),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return "Hãy nhập tiêu đề";
                }
                _formData["title"] = value;
                return null;
              },
            ),
            inputLabelWithPadding("Số tiền nợ"),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: formFieldDecor(icon: const Icon(CupertinoIcons.money_dollar)),
              keyboardType: TextInputType.number,
              validator: (value) => numericValidator(value, "amount"),
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
                onDataChanged: (period, minPayment, duedate, interest) {
                  if(duedate != null) _formData["duedate"] = duedate;
                  if(interest != null) _formData["interest"] = interest;
                  if(minPayment != null)_formData["min_payment"] = minPayment;
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
