import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/models/accounts.model.dart';
import 'package:saving_app/providers/local/model_providers/savings_repo.dart';
import 'package:saving_app/screens/style/styles.dart';
import 'package:saving_app/utils/randoms.dart';

class NewSavingForm extends StatefulWidget {
  const NewSavingForm({super.key});

  @override
  State<NewSavingForm> createState() => _NewSavingFormState();
}

class _NewSavingFormState extends State<NewSavingForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};
  final _deadlineController = TextEditingController();
  var _hasGoal = false;
    
  void _onSubmit() {
    _formKey.currentState!.save();
    if(_formKey.currentState!.validate()){
      var repo = context.read<SavingRepository>();
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
      repo.put(newSaving);
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      inputLabelWithPadding("Interest"),
                      TextFormField(
                        initialValue: "0.0",
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: addRecordFormFieldStyle(icon: const Icon(CupertinoIcons.money_dollar)),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          final data = _formData["interest"];
                          if(_formData["period"] == null || _formData["period"] == 0) {
                            if(data == null) {
                              return null;
                            }
                            if(data == 0){
                              return null;
                            }
                            return "Please fill 'Period' also";
                          }
                          if(data == null) {
                            return "Please input";
                          }
                          if (data <= 0) {
                            return "Must be greater than 0";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _formData["interest"] = double.parse(newValue!);
                        },
                        onFieldSubmitted: (value) {
                          _formData["interest"] = double.parse(value);
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
                      inputLabelWithPadding("Period"),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: addRecordFormFieldStyle(icon: const Icon(CupertinoIcons.money_dollar)),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          final data = _formData["period"];
                          if(_formData["interest"] == null || _formData["interest"] == 0.0){
                            if(data == null) {
                              return null;
                            }
                            if(data == 0) {
                              return null;
                            }
                            return "Please fill 'Interest' also";
                          }
                          if(data == null) {
                            return "Please input";
                          }
                          // int parsedAmount = int.parse(value);
                          if (data <= 0) {
                            return "Period should be greater than 0";
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          _formData["period"] = int.parse(value);
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
                  "Add a goal",
                  style: TextStyle(fontSize: 14.0),
                ),
                const SizedBox(width: 5.0,),
                const Text(
                  "(optional)",
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
            inputLabelWithPadding("Title"),
            TextFormField(
              enabled: _hasGoal,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: addRecordFormFieldStyle(icon: const Icon(Icons.label_outline)),
              validator: (value) {
                if(!_hasGoal) {
                  return null;
                }
                if(value == null || value.isEmpty) {
                  return "Please put a title";
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
                      inputLabelWithPadding("Target"),
                      TextFormField(
                        enabled: _hasGoal,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: addRecordFormFieldStyle(icon: const Icon(CupertinoIcons.money_dollar)),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if(!_hasGoal) {
                            return null;
                          }
                          final data = _formData["targetAmount"];
                          if(data == null) {
                            return "Please input";
                          }
                          // int parsedAmount = int.parse(value);
                          if (data <= _formData["amount"]) {
                            return "Must be more than amount";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _formData["targetAmount"] = int.parse(newValue!);
                        },
                        onFieldSubmitted: (value) {
                          _formData["targetAmount"] = int.parse(value);
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
                      inputLabelWithPadding("Deadline"),
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