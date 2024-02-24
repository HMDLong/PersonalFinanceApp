import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/utils/times.dart';
import 'package:saving_app/viewmodels/transact/transact_viewmodel.dart';

final recordLogViewModelProvider = ChangeNotifierProvider((ref) {
  return RecordsLogViewModel(repo: ref.watch(transactionsViewModelProvider));
});

class RecordsLogViewModel extends ChangeNotifier {
  TimeRange _currentTime = getRangeOfDay();
  TransactionType _currentTransactType = TransactionType.expense;
  CustomCategory? _currentCategory;

  final TransactionViewModel repo;
  RecordsLogViewModel({required this.repo});

  TimeRange get currentTime => _currentTime;
  TransactionType get currentTransactType => _currentTransactType;
  CustomCategory? get currentCategory => _currentCategory;

  set timeRange(TimeRange value) {
    _currentTime = value;
    notifyListeners();
  }

  set transactType(TransactionType value) {
    _currentTransactType = value;
    notifyListeners();
  }
  
  set category(CustomCategory value) {
    _currentCategory = value;
    notifyListeners();
  }

  List<Transaction> get displayData {
    final allTransacts = repo.getTransactions();
    final res = allTransacts.where(_filter).toList();
    res.sort(_sort);
    return res;    
  }

  int _sort(Transaction a, Transaction b) {
    return a.timestamp.compareTo(b.timestamp);
  }

  bool _filter(Transaction transact) {
    if(!transact.paid) return false;
    if(!_currentTime.contain(transact.timestamp)) return false;
    if(transact.transactType != _currentTransactType) return false;
    if(_currentCategory != null && transact.categoryId != _currentCategory!.id) return false;
    return true;
  }
}