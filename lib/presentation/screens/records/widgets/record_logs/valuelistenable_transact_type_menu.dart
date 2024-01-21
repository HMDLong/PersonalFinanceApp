import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/transaction.model.dart';

class ValueListenableTransactTypeMenu extends StatefulWidget {
  final List<Map<String, dynamic>> menuItems;
  final void Function(TransactionType newType) onTypeChanged;
  final List<Transaction> Function(Box<Transaction>, {TransactionType? type}) getTransaction;
  final ValueListenable listenable;

  const ValueListenableTransactTypeMenu({
    super.key,
    required this.menuItems,
    required this.listenable,
    required this.onTypeChanged, 
    required this.getTransaction,
  });

  @override
  State<ValueListenableTransactTypeMenu> createState() => _ValueListenableTransactTypeMenuState();
}

class _ValueListenableTransactTypeMenuState extends State<ValueListenableTransactTypeMenu> {
  TransactionType _currentTransactionTab = TransactionType.expense;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.2),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: widget.menuItems.map((e) {
            return Expanded(
              child: GestureDetector(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: _currentTransactionTab == e["value"] ? Colors.blueAccent.shade700 : Colors.white,
                  ),
                  child: Column(
                    children: [
                      Text(
                        e["name"],
                        style: TextStyle(
                          color: _currentTransactionTab == e["value"] ? Colors.white : Colors.black,
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: widget.listenable, 
                        builder: (context, box, _) {
                          final items = widget.getTransaction(box, type: e["value"]);
                          final sum = items.isEmpty ? 
                                      0 
                                      : items.map(
                                        (e) => e.amount
                                      ).reduce(
                                        (value, element) => value + element
                                      );
                          return Text(
                            "${NumberFormat.decimalPattern().format(sum)} VND",
                            style: TextStyle(
                              color: _currentTransactionTab == e["value"] ? Colors.white : Colors.black,
                              fontSize: 12
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    _currentTransactionTab = e["value"];
                    widget.onTypeChanged(e["value"]);
                  });
                },
              )
            );
          }
        ).toList(),
      )
    );
  }
}
