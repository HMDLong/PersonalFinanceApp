import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/constants/built_in_categories.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/presentation/managers/transaction_manager.dart';
import 'package:saving_app/utils/randoms.dart';
import 'package:saving_app/utils/times.dart';

class DemoPanel extends StatelessWidget {
  const DemoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo Panel"),
      ),
      body: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () => _addMockTransaction(context), 
            icon: const Icon(Icons.add),
            label: const Text("Thêm 5000 bản ghi thu chi"),
          ),
        ],
      ),
    );
  }

  void _addMockTransaction(BuildContext context) {
    final transactProvider = context.read<TransactionProvider>();
    final timeRange = TimeRange(
      start: DateTime(2023, 1, 1), 
      end: DateTime.now().toDateOnly()
    ).getRangeDates();
    final rangeDuration = timeRange.length;
    final datas = List<Transaction>.generate(
      5000, (index) {
        final cate = _randomCategory();
        return Transaction(
          id: getRandomKey(), 
          timestamp: timeRange[Random().nextInt(rangeDuration)], 
          amount: Random().nextInt(100) * 10000 * (
            cate.type == TransactionType.income
            ? 1
            : -1
          ), 
          categoryId: cate.id!,
        );
      }
    );
    for(final data in datas) {
      transactProvider.putTransaction(data);
      
    }
  }

  TransactCategory _randomCategory() {
    final group = builtInCategories[Random().nextInt(builtInCategories.length)];
    return group.subCategories[Random().nextInt(group.subCategories.length)];
  }
}