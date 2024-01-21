import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/data/local/model_repos/records/category_repository.dart';
import 'package:saving_app/data/models/plan_transaction.model.dart';
import 'package:saving_app/presentation/managers/plan_manager.dart';

class PlanTransactionCard extends StatefulWidget {
  final PlanTransaction planTransaction;
  const PlanTransactionCard({super.key, required this.planTransaction});

  @override
  State<PlanTransactionCard> createState() => _PlanTransactionCardState();
}

class _PlanTransactionCardState extends State<PlanTransactionCard> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(widget.planTransaction.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.blue.shade600,
            icon: CupertinoIcons.pencil_outline,
            borderRadius: BorderRadius.circular(10),
            onPressed: (context) {

            }
          ),
          SlidableAction(
            backgroundColor: Colors.red.shade600,
            icon: CupertinoIcons.delete,
            borderRadius: BorderRadius.circular(10),
            onPressed: (context) {

            }
          ),
        ],
      ),
      child: SizedBox(
        height: 80.0,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.planTransaction.title, style: const TextStyle(fontSize: 12),),
                    Text(NumberFormat.decimalPattern().format(widget.planTransaction.amount), style: const TextStyle(fontSize: 12)),
                    Text("${context.read<CategoryRepository>().getAt(widget.planTransaction.categoryId)?.name}", style: const TextStyle(fontSize: 12))
                  ],
                )
              ),
              Expanded(
                flex: 2,
                child: Text("${widget.planTransaction.status}", style: const TextStyle(fontSize: 10),),
              ),
              Expanded(
                flex: 2,
                child: Switch(
                  value: widget.planTransaction.notificationId > 0,
                  onChanged: (switchOn) {
                    context.read<PlanController>().setNotification(widget.planTransaction.id, switchOn);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: const BoxDecoration(
                    // color: Colors.blueAccent.shade700,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)
                    )
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.keyboard_double_arrow_left_rounded , color: Colors.black54,),
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
}