import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saving_app/screens/style/styles.dart';

class InstallmentForm extends StatefulWidget {
  final Map<String, dynamic> formData;
  const InstallmentForm({Key? key, required this.formData}) : super(key: key);

  @override
  State<InstallmentForm> createState() => _InstallmentFormState();
}

class _InstallmentFormState extends State<InstallmentForm> {
  final _duedateController = TextEditingController();
  
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
        _duedateController.text = DateFormat.yMd().format(pickedDeadline);
        widget.formData["duedate"] = pickedDeadline;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                    decoration: addRecordFormFieldStyle(icon: const Icon(CupertinoIcons.percent)),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if(value == null || widget.formData["interest"] == null) {
                        return "Please input";
                      }
                      if (widget.formData["interest"] <= 0) {
                        return "Must be greater than 0";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      widget.formData["interest"] = double.parse(newValue!);
                    },
                    onFieldSubmitted: (value) {
                      widget.formData["interest"] = double.parse(value);
                    },
                  )
                ],
              ),
            ),
            const SizedBox(width: 5.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  inputLabelWithPadding("Due date"),
                  TextFormField(
                    controller: _duedateController,
                    readOnly: true,
                    onTap: () => _selectDate(),
                    decoration: addRecordFormFieldStyle(icon: const Icon(Icons.calendar_month)),
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return "Please choose a date";
                      }
                      if(DateTime.now().isAfter(widget.formData["duedate"])){
                        return "Choose valid date";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  inputLabelWithPadding("Pay per"),
                  TextFormField(
                    initialValue: "0",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: addRecordFormFieldStyle(suffix: Text("months", style: inputTextSuffixStyle(),)),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if(value == null || widget.formData["phase"] == null) {
                        return "Please input";
                      }
                      if (widget.formData["phase"] <= 0) {
                        return "Must be greater than 0";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      widget.formData["phase"] = double.parse(newValue!);
                    },
                    onFieldSubmitted: (value) {
                      widget.formData["phase"] = double.parse(value);
                    },
                  )
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
                    initialValue: "0",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: addRecordFormFieldStyle(suffix: Text("months", style: inputTextSuffixStyle(),)),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if(value == null || widget.formData["period"] == null) {
                        return "Please input";
                      }
                      if (widget.formData["interest"] <= 0) {
                        return "Must be greater than 0";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      widget.formData["period"] = int.parse(newValue!);
                    },
                    onFieldSubmitted: (value) {
                      widget.formData["period"] = int.parse(value);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}