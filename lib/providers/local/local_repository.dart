import 'package:flutter/material.dart';

abstract class BaseLocalRepository<T> extends ChangeNotifier {
  final List<T> items = [];

  void put(T value);
  void putAll(List<T> values);
  T? getAt(dynamic id);
  List<T> getAll();
  void updateAt(dynamic id, T newT);
  void deleteAt(dynamic id);
  void deleteAll();
}