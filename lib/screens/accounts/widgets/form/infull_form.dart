import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saving_app/screens/style/styles.dart';

class InfullForm extends StatefulWidget {
  final Map<String, dynamic> formData;
  const InfullForm({Key? key, required this.formData}) : super(key: key);

  @override
  State<InfullForm> createState() => _InfullFormState();
}

class _InfullFormState extends State<InfullForm> {
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
        widget.formData["deadline"] = pickedDeadline;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
                  if(value == null) {
                    return "Please choose a date";
                  }
                  if(DateTime.now().isAfter(widget.formData["deadline"])){
                    return "Choose valid date";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
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
      ],
    );
  }
}