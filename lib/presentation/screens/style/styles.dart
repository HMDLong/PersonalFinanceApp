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


InputDecoration formFieldDecor({
  Icon? icon, 
  Widget? suffix,
  String? hintText,
  Widget? label
}) =>
  InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
    icon: icon,
    suffix: suffix,
    fillColor: Colors.transparent,
    hintText: hintText,
    label: label,
    labelStyle: const TextStyle(
      fontSize: 14,
    ),
    floatingLabelBehavior: FloatingLabelBehavior.never
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