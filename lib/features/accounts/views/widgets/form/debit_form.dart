import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:saving_app/data/local/model_repos/account/debit_repo.dart';
import 'package:saving_app/features/accounts/models/debit.dart';
import 'package:saving_app/features/accounts/viewmodels/accounts.viewmodel.dart';
import 'package:saving_app/presentation/screens/style/styles.dart';
import 'package:saving_app/utils/randoms.dart';

class NewDebitForm extends ConsumerStatefulWidget {
  final Debit? prefill;
  const NewDebitForm({super.key, this.prefill});

  @override
  ConsumerState<NewDebitForm> createState() => _NewDebitFormState();
}

class _NewDebitFormState extends ConsumerState<NewDebitForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};
    
  Future<void> _onSubmit() async {
    _formKey.currentState!.save();
    if(_formKey.currentState!.validate()){
      // var repo = context.read<DebitRepository>();
      final newDebit = Debit(
          id: widget.prefill == null ? getRandomKey() : widget.prefill!.id,
          amount: _formData["amount"] as int,
          title: _formData["title"] as String,
        );
      if(widget.prefill == null) {
        print("add account");
        await ref.read(accountsProvider).addAccount(newDebit);
      } else {
        await ref.read(accountsProvider).updateAccount(newDebit);
      }
    }
  }

  @override
  void initState() {
    _formData["amount"] = widget.prefill?.amount;
    _formData["title"] = widget.prefill?.title;
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
              initialValue: widget.prefill != null ? widget.prefill!.title : null,
              decoration: formFieldDecor(icon: const Icon(Icons.title)),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return "Hãy nhập tiêu đề";
                }
                _formData["title"] = value;
                return null;
              },
              // onFieldSubmitted: (value) {
              //   _formData["title"] = value;
              // },
              onSaved: (newValue) {
                _formData["title"] = newValue;
              },
            ),
            inputLabelWithPadding("Số tiền"),
            TextFormField(
              initialValue: widget.prefill != null
                            ? "${NumberFormat.decimalPattern().format(widget.prefill!.amount)}"
                            : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: formFieldDecor(
                icon: const Icon(CupertinoIcons.money_dollar),
                suffix: const Text('VND'),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return "Hãy nhập số tiền";
                }
                var parsedAmount = int.tryParse(value);
                if(parsedAmount == null) {
                  parsedAmount = int.tryParse(value.replaceAll(',', ''));
                  if(parsedAmount == null) {
                    return "Hãy nhập số hợp lệ";
                  }
                }
                if (parsedAmount <= 0) {
                  return "Số tiền cần lớn hơn 0";
                }
                _formData["amount"] = parsedAmount;
                return null;
              },
              // onSaved: (newValue) {
              //   _formData["amount"] = int.parse(newValue!);
              // },
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: ElevatedButton(
                child: const Text("Xác nhận"),
                onPressed: () {
                  _onSubmit()
                  .then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ok")));
                    Navigator.of(context).pop();
                  });
                  // .onError((error, stackTrace) {
                  //   print(StackTrace.current);
                  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("error")));
                  //   Navigator.of(context).pop();
                  // });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}