import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saving_app/presentation/screens/style/styles.dart';

class CustomDatePicker extends StatefulWidget {
  final String? label;
  final void Function(DateTime) onDatePicked;
  const CustomDatePicker({super.key, this.label, required this.onDatePicked});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final _datePickerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        inputLabelWithPadding(widget.label ?? "Thời gian"),
        TextFormField(
          controller: _datePickerController,
          readOnly: true,
          decoration: formFieldDecor(icon: const Icon(CupertinoIcons.calendar)),
          onTap: _selectDate,
          validator: (value) {
            if(value == null || value.isEmpty) {
              return "Hãy điền thông tin";
            }
            return null;
          },
        ),
      ],
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
        widget.onDatePicked(pickedDate);
        _datePickerController.text = DateFormat(DateFormat.DAY).format(pickedDate);
      });
    }
  }
}