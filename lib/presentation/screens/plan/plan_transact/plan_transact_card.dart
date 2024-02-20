import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/data/local/model_repos/records/category_repository.dart';
import 'package:saving_app/data/models/transaction.model.dart';
import 'package:saving_app/presentation/managers/plan_manager.dart';
import 'package:saving_app/utils/format.dart';
import 'package:saving_app/viewmodels/transact/plan_transact_viewmodel.dart';
import 'package:saving_app/viewmodels/transact/transact_viewmodel.dart';

class PlanTransactionCard extends ConsumerStatefulWidget {
  final Transaction planTransaction;
  const PlanTransactionCard({super.key, required this.planTransaction});

  @override
  ConsumerState<PlanTransactionCard> createState() => _PlanTransactionCardState();
}

class _PlanTransactionCardState extends ConsumerState<PlanTransactionCard> {
  
  @override
  Widget build(BuildContext context) {
    final planTransact = ref.watch(planTransactById(widget.planTransaction.planTransactId!));
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat(DateFormat.ABBR_WEEKDAY).format(widget.planTransaction.timestamp), 
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        "${widget.planTransaction.timestamp.day} Th${widget.planTransaction.timestamp.month}", 
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  )
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.planTransaction.planTransactTitle!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                      Text("${NumberFormat.decimalPattern().format(widget.planTransaction.amount)} VND", style: const TextStyle(fontSize: 12)),
                      Text("${context.read<CategoryRepository>().getAt(widget.planTransaction.categoryId)?.name}", style: const TextStyle(fontSize: 12))
                    ],
                  )
                ),
                // Expanded(
                //   flex: 2,
                //   child: Text("${widget.planTransaction.paid}", style: const TextStyle(fontSize: 10),),
                // ),
                Expanded(
                  flex: 2,
                  child: widget.planTransaction.paid
                  ? const SizedBox(width: 0.1,)
                  : Switch(
                    value: ref.watch(planTransactNoti(widget.planTransaction.planTransactId!)).when(
                      data: (data) => data, 
                      error: (error, _) => throw error, 
                      loading: () => false,
                    ),
                    onChanged: (switchOn) {
                      ref.read(planTransactionProvider.notifier).setPlanTransactNoti(widget.planTransaction.planTransactId!, switchOn);
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
      ),
    );
  }
}