import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget inputLabelWithPadding(String label) =>
  Padding(
    padding: const EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 5.0),
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.bold
      ),
    ),
  );


InputDecoration addRecordFormFieldStyle({
  Icon? icon, 
  Widget? suffix,
  String? hintText,
}) =>
  InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
    prefixIcon: icon,
    suffix: suffix,
    fillColor: Colors.transparent,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: const BorderSide(width: 0.5),
    ),
    hintText: hintText
  );

TextStyle inputTextSuffixStyle() => 
  const TextStyle(
    fontSize: 12,
    color: Colors.black45
  );

defaultStyledAppBar({
  void Function()? onBackPressed, 
  required String title,
  PreferredSizeWidget? bottom,
}) {
  return AppBar(
    leading: onBackPressed == null
    ? null
    : IconButton(
      icon: const Icon(
        CupertinoIcons.back,
        color: Colors.black,
      ),
      onPressed: () => onBackPressed(),
    ),
    elevation: 0,
    backgroundColor: Colors.white,
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.black
      ),
    ),
    bottom: bottom,
  );
}