import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../constants/built_in_categories.dart';
import '../../../models/category.model.dart';
import '../../../models/transaction.model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../edit_record.screen.dart';


class TransactionCard extends StatefulWidget {
  final Transaction transaction;
  const TransactionCard({Key? key, required this.transaction}) : super(key : key);

  @override
  State<StatefulWidget> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {

  @override
  Widget build(BuildContext context) {
    TransactCategory currentCategory = findCategoryById(widget.transaction.categoryId);
    return Slidable(
      key: ValueKey(widget.transaction.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(), 
        children: [
          SlidableAction(
            onPressed: (context) => _updateTransaction(context, widget.transaction),
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            icon: CupertinoIcons.pencil_outline,
            label: "Edit",
          ),
          SlidableAction(
            onPressed: (context) => _deleteTransaction(context, widget.transaction),
            backgroundColor: Colors.red.shade600,
            foregroundColor: Colors.white,
            icon: CupertinoIcons.delete,
            label: "Edit",
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  constraints: const BoxConstraints(
                    minHeight: 45.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Icon(
                    IconData(currentCategory.icon, fontFamily: "MaterialIcons"),
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(currentCategory.name),
                    const SizedBox(height: 5,),
                    Text(
                      DateFormat(DateFormat.ABBR_MONTH_DAY).add_jm().format(widget.transaction.timestamp),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${NumberFormat.decimalPattern().format(widget.transaction.amount)} VND"),
                    const SizedBox(height: 5,),
                    Text(
                      "${widget.transaction.description}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10,),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.shade700,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)
                    )
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.keyboard_double_arrow_left_rounded , color: Colors.white,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  _updateTransaction(BuildContext context, Transaction transaction) {
    pushNewScreen(
      context, 
      screen: const EditTransactionScreen(),
    );
  }
  
  _deleteTransaction(BuildContext context, Transaction transaction) async {
    await transaction.delete();
  }
}

TransactCategory findCategoryById(String id) {
  for(var category in builtInCategories) {
    final res = category.subCategories.where(
      (element) => element.id == id
    );
    if(res.isNotEmpty) {
      return res.first;
    }
  }
  throw Exception("No such item. Cant find category with id{$id}");
}
