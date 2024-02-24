import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/data/models/plan_transaction.model.dart';
import 'package:saving_app/presentation/screens/style/styles.dart';
import 'package:saving_app/viewmodels/transact/plan_transact_viewmodel.dart';

class EventPicker extends ConsumerStatefulWidget {
  final void Function(PlanTransaction value) onPicked;
  final TransactionType type;
  const EventPicker({super.key, required this.onPicked, required this.type});

  @override
  ConsumerState<EventPicker> createState() => _EventPickerState();
}

class _EventPickerState extends ConsumerState<EventPicker> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        readOnly: true,
        controller: controller,
        decoration: formFieldDecor(
          icon: const Icon(Icons.event_available),
          label: const Text("Sự kiện"),
        ),
        onTap: _selectEvent,
      ),
    );
  }

  void _selectEvent() async {
    PlanTransaction? planTransact = await showModalBottomSheet(
      context: context, 
      builder: (context) {
        return EventBottomSheet(
          type: widget.type,
        );
      }
    );

    if(planTransact != null) {
      setState(() {
        widget.onPicked(planTransact);
        controller.text = "${planTransact.title} (${NumberFormat.decimalPattern().format(planTransact.amount)})";
      });
    }
  }
}

class EventBottomSheet extends ConsumerStatefulWidget {
  final TransactionType type;
  const EventBottomSheet({super.key, required this.type});

  @override
  ConsumerState<EventBottomSheet> createState() => _EventBottomSheetState();
}

class _EventBottomSheetState extends ConsumerState<EventBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0), 
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0), 
                topRight: Radius.circular(10.0),
              ),
              color: Colors.blue,
            ),
            child: const Text(
              "Chọn 1 sự kiện",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, _) {
              // final events = ref.watch(planTransactionProvider).getPlanTransactsByType(widget.type);
              final events = ref.watch(
                switch(widget.type) {
                  TransactionType.income => incomeProvider,
                  TransactionType.expense => expensesProvider,
                  TransactionType.transact => transactProvider,
                }
              );
              return events.when(
                data: (data) =>
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: data.isEmpty
                      ? const Center(
                        child: Text("không có sự kiện liên quan"),
                      )
                      : Column(
                        children: data.map((event) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(event);
                            },
                            child: ListTile(
                              title: Text(event.title),
                              subtitle: Text(DateFormat.yMEd().format(event.transactDate!)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                error: (error, stackTrace) => SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Center(child: Text("$error")),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
              );
            }
          ),
        ],
      ),
    );
  }
}
