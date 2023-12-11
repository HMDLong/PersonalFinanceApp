import 'package:flutter/material.dart';

class CustomForm extends StatefulWidget {
  final GlobalKey formKey;
  final List<CustomFormItem> formItems;
  final void Function(FormValue formValue) onSubmit;

  const CustomForm({
    super.key, 
    required this.formKey, required this.formItems, required this.onSubmit,
  });

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class FormValue {
}

class CustomFormItem {
  Widget build() {
    return TextFormField();
  }
}

class _CustomFormState extends State<CustomForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.formItems.map((e) => e.build()).toList(),
      ),
    );
  }
}