import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:saving_app/constants/built_in_categories.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/data/local/model_repos/account/account_repo.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../edit_record.screen.dart';


class TransactionCard extends StatefulWidget {
  final Transaction transaction;
  const TransactionCard({Key? key, required this.transaction}) : super(key : key);

  @override
  State<StatefulWidget> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  Account? getAccount(String id) {
    return AccountManager.of(context).getAccountById(id);
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(widget.transaction.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => _updateTransaction(context, widget.transaction),
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(10),
            icon: CupertinoIcons.pencil_outline,
            label: "Sửa",
          ),
          SlidableAction(
            onPressed: (context) => _deleteTransaction(context, widget.transaction),
            backgroundColor: Colors.red.shade600,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(10),
            icon: CupertinoIcons.delete,
            label: "Xóa",
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
                    minHeight: 60.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Icon(
                    findCategoryById(widget.transaction.categoryId).icon,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${findCategoryById(widget.transaction.categoryId).name}"),
                    const SizedBox(height: 5,),
                    Text(
                      DateFormat(DateFormat.ABBR_MONTH_DAY).add_jm().format(widget.transaction.timestamp),
                      style: const TextStyle(fontSize: 10),
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Từ: ", style: TextStyle(color: Colors.black45, fontSize: 10)),
                        Text(
                          widget.transaction.transactAccountId == null 
                          ? "Không xác định" 
                          : "${getAccount(widget.transaction.transactAccountId!)?.title}",
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${NumberFormat.decimalPattern().format(widget.transaction.amount)} VND",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: widget.transaction.amount > 0 
                              ? const Color.fromARGB(255, 105, 240, 139)
                              : Colors.red,
                      ),
                    ),
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
      screen: TransactionInput(transaction: transaction,),
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
