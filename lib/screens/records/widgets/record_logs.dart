import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:saving_app/constants/constants.dart';
import 'package:saving_app/models/transaction.model.dart';
import 'package:saving_app/screens/records/add_record.screen.dart';
import 'package:saving_app/screens/records/widgets/timepicker_custom_dialog.dart';
import 'package:saving_app/screens/records/widgets/transact_type_menu.dart';
import 'package:saving_app/screens/records/widgets/valuelistenable_transact_type_menu.dart';
import '../../../utils/times.dart';
import 'transaction_card.dart';

class RecordLogs extends StatefulWidget {
  const RecordLogs({super.key});

  @override
  State<StatefulWidget> createState() => _RecordLogsState();
}

class _RecordLogsState extends State<RecordLogs>{
  TimeRange _currentTime = getRangeOfDay();

  TransactionType _currentTransactionTab = TransactionType.expense;
  int _currentTransactionFilter = 0;
  late Box<Transaction> _transactionsBox;

  @override
  void initState() {
    _transactionsBox = Hive.box<Transaction>(transactionBoxName);
    super.initState();
  }

  List<Transaction> getTransaction(
    Box<Transaction> transactionsBox,
    {TransactionType? type}
  ) {
    List<Transaction> filteredTransactions = transactionsBox.values
    .where((transaction) =>
      // filter by choosen time
      _currentTime.contain(transaction.timestamp)
      // true
    ).where((transaction) {
      // filter by transaction type: expense/income
        var transactType = type ?? _currentTransactionTab;
        return switch(transactType) {
          TransactionType.expense => transaction.amount < 0,
          TransactionType.income => transaction.amount > 0,
          _ => true,
        };
      }
    ).toList();
    filteredTransactions.sort(((a, b) =>
      a.timestamp.isAfter(b.timestamp) ?
        - 1
        : a.timestamp.isAtSameMomentAs(b.timestamp) ? 0 : 1
    ));
    return filteredTransactions;
  }

  List<Map<String, dynamic>> _transactTypeMenuItems() => [
    {
      "name": "Expense",
      "value": TransactionType.expense,
    },
        {
      "name": "Income",
      "value": TransactionType.income,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTimePicker(
          onTimeChanged: (value) {
            setState(() {
              _currentTime = value;
            });
          }
        ),
        ValueListenableTransactTypeMenu(
          menuItems: _transactTypeMenuItems(), 
          listenable: _transactionsBox.listenable(), 
          onTypeChanged: (newType) {
            setState(() {
              _currentTransactionTab = newType;
            });
          }, 
          getTransaction: getTransaction
        ),
        Row(
          children: [
            const SizedBox(width: 5.0,),
            GestureDetector(
              child: Text(
                "By Categories",
                style: TextStyle(
                  color: _currentTransactionFilter == 1 ? CupertinoColors.activeBlue : Colors.black
                ),
              ),
              onTap: () => setState(() {
                _currentTransactionFilter = 1;
              }),
            ),
            const SizedBox(width: 20.0,),
            GestureDetector(
              child: Text(
                "All",
                style: TextStyle(
                  color: _currentTransactionFilter == 0 ? CupertinoColors.activeBlue : Colors.black
                ),
              ),
              onTap: () => setState(() {
                _currentTransactionFilter = 0;
              }),
            ),
            const SizedBox(width: 65.0,),
            IconButton(
              onPressed: () {
                pushNewScreen(
                  context, 
                  screen: const AddRecordScreen(),
                  withNavBar: true,
                );
              }, 
              icon: const Icon(CupertinoIcons.calendar_badge_plus),
            ),
            IconButton(
              onPressed: () {
                
              }, 
              icon: const Icon(CupertinoIcons.search),
            ),
            IconButton(
              onPressed: () {
                
              }, 
              icon: const Icon(CupertinoIcons.line_horizontal_3_decrease),
            ),
          ],
        ),
        ValueListenableBuilder(
          valueListenable: _transactionsBox.listenable(), 
          builder: (context, Box<Transaction> items, _) {
            List<Transaction> displayItems = getTransaction(items);
            return displayItems.isEmpty 
            ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "No record today",
                style: TextStyle(
                  color: Colors.black45,
                ),
              ),
            )
            : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, index) {
                return TransactionCard(transaction: displayItems[index]);
              }, 
              itemCount: displayItems.length,
            );
          },
        ),
      ],
    );
  }
}
