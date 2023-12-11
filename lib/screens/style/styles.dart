import 'package:flutter/material.dart';

Widget inputLabelWithPadding(String label) =>
  Padding(
    padding: const EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.bold
      ),
    ),
  );


InputDecoration addRecordFormFieldStyle({Icon? icon, Widget? suffix}) =>
  InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
    prefixIcon: icon,
    suffix: suffix,
    fillColor: Colors.transparent,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: const BorderSide(),
    ),
  );

TextStyle inputTextSuffixStyle() => 
  const TextStyle(
    fontSize: 12,
    color: Colors.black45
  );