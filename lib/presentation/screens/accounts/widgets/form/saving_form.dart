import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/domain/providers/savings_provider.dart';
import 'package:saving_app/presentation/screens/style/styles.dart';
import 'package:saving_app/utils/randoms.dart';

class NewSavingForm extends ConsumerStatefulWidget {
  final Saving? prefill;
  const NewSavingForm({super.key, this.prefill});

  @override
  ConsumerState<NewSavingForm> createState() => _NewSavingFormState();
}

class _NewSavingFormState extends ConsumerState<NewSavingForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};
  final _deadlineController = TextEditingController();
  var _hasGoal = false;
    
  void _onSubmit() {
    _formKey.currentState!.save();
    if(_formKey.currentState!.validate()){
      // var repo = context.read<SavingRepository>();
      final newSaving = Saving(id: getRandomKey());
      newSaving.interest = _formData["interest"] ?? 0.0;
      newSaving.amount = _formData["amount"] ?? 0;
      newSaving.title = _formData["title"];
      newSaving.period = _formData["period"] ?? 0;
      if(_hasGoal){
        newSaving.goal = Goal(
          targetAmount: _formData["targetAmount"] as int,
          title: _formData["goalTitle"] as String,
          deadline: _formData["deadline"] as DateTime,
        );
      }
      // repo.put(newSaving);
      ref.read(savingProvider.notifier).newSaving(newSaving)
      .then((_) => Navigator.of(context).pop());
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
            inputLabelWithPadding("Tiêu đề"),
            TextFormField(
              decoration: addRecordFormFieldStyle(icon: const Icon(Icons.title)),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return "Hãy điền";
                }
                _formData["title"] = value;
                return null;
              },
              // onFieldSubmitted: (value) {
              //   _formData["title"] = value;
              // },
              // onSaved: (newValue) {
              //   _formData["title"] = newValue;
              // },
            ),
            inputLabelWithPadding("Số tiền đã tiết kiệm"),
            TextFormField(
              initialValue: "0",
              decoration: addRecordFormFieldStyle(icon: const Icon(CupertinoIcons.money_dollar)),
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return "Hãy điền";
                }
                try {
                  int parsedAmount = int.parse(value);
                  if (parsedAmount < 0) {
                    return "Cần dương";
                  }
                  _formData["amount"] = parsedAmount;
                } catch(e) {
                  return "Cần là số nguyên";
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0,),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      inputLabelWithPadding("Lãi suất"),
                      TextFormField(
                        initialValue: "0.0",
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: addRecordFormFieldStyle(icon: const Icon(CupertinoIcons.money_dollar)),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return "Hãy điền";
                          }
                          final parsed = double.tryParse(value);
                          if(_formData["period"] == null || _formData["period"] == 0) {
                            if(parsed == null || parsed == 0) {
                              return null;
                            }
                            return "Hãy điền";
                          }
                          if(parsed == null) {
                            return "Cần là 1 số";
                          }
                          if (parsed <= 0) {
                            return "Cần là số dương";
                          }
                          _formData["interest"] = parsed;
                          return null;
                        },
                        onSaved: (newValue) {
                          _formData["interest"] = double.parse(newValue!);
                        },
                        // onFieldSubmitted: (value) {
                        //   _formData["interest"] = double.parse(value);
                        // },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      inputLabelWithPadding("Kỳ hạn"),
                      TextFormField(
                        initialValue: "0",
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: addRecordFormFieldStyle(icon: const Icon(CupertinoIcons.money_dollar)),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return "Hãy nhập";
                          }
                          final parsed = int.tryParse(value);
                          if(parsed == null) {
                            return "Cần là số";
                          }
                          if(_formData["interest"] == null || _formData["interest"] == 0.0){
                            if(parsed == 0) {
                              return null;
                            }
                            return "Hãy nhập 'Lãi suất'";
                          }
                          if (parsed <= 0) {
                            return "Cần lớn hơn 0";
                          }
                          return null;
                        },
                      ),
                    ],
                  )
                )
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                const SizedBox(width: 10, height: 20,),
                const Text(
                  "Thêm mục tiêu",
                  style: TextStyle(fontSize: 14.0),
                ),
                const SizedBox(width: 5.0,),
                const Text(
                  "(tùy chọn)",
                  style: TextStyle(
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(width: 10.0,),
                Checkbox(
                  value: _hasGoal, 
                  onChanged: (newValue) {
                    setState(() {
                      _hasGoal = !_hasGoal;
                    });
                  }
                )
              ],
            ),
            inputLabelWithPadding("Tiêu đề"),
            TextFormField(
              enabled: _hasGoal,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: addRecordFormFieldStyle(icon: const Icon(Icons.label_outline)),
              validator: (value) {
                if(!_hasGoal) {
                  return null;
                }
                if(value == null || value.isEmpty) {
                  return "Hãy thêm tiêu đề";
                }
                return null;
              },
              onSaved: (newValue) {
                _formData["goalTitle"] = newValue;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      inputLabelWithPadding("Số tiền mục tiêu"),
                      TextFormField(
                        enabled: _hasGoal,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: addRecordFormFieldStyle(icon: const Icon(CupertinoIcons.money_dollar)),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if(!_hasGoal) {
                            return null;
                          }
                          if(value == null || value.isEmpty) {
                            return "Hãy điền";
                          } 
                          final parsedAmount = int.tryParse(value);
                          if(parsedAmount == null) {
                            return "Cần là số dương";
                          }
                          if (parsedAmount <= (_formData["amount"] ?? 0)) {
                            return "Cần phải lớn hơn số tiền gốc";
                          }
                          _formData["targetAmount"] = parsedAmount;
                          return null;
                        },
                        onSaved: (newValue) {
                          if(_hasGoal) {
                            _formData["targetAmount"] = int.parse(newValue!);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      inputLabelWithPadding("Ngày đến hạn"),
                      TextFormField(
                        enabled: _hasGoal,
                        controller: _deadlineController,
                        readOnly: true,
                        onTap: () => _selectDate(),
                        decoration: addRecordFormFieldStyle(icon: const Icon(Icons.calendar_month)),
                        validator: (value) {
                          if(!_hasGoal) {
                            return null;
                          }
                          if(_formData["deadline"] == null) {
                            return "Please choose a date";
                          }
                          if(DateTime.now().isAfter(_formData["deadline"])){
                            return "Choose valid date";
                          }
                          return null;
                        },
                      ),
                    ],
                  )
                )
              ],
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
  
  _selectDate() async {
    final now = DateTime.now();
    DateTime? pickedDeadline = await showDatePicker(
      context: context, 
      initialDate: now, 
      firstDate: DateTime(now.year), 
      lastDate: DateTime(now.year + 10),
    );

    if(pickedDeadline != null) {
      setState(() {
        _deadlineController.text = DateFormat.yMd().format(pickedDeadline);
        _formData["deadline"] = pickedDeadline;
      });
    }
  }
}