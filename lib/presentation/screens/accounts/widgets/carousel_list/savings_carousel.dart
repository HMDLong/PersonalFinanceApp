import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:saving_app/data/models/accounts.model.dart';
import 'package:saving_app/domain/providers/savings_provider.dart';

class SavingsCarousel extends ConsumerStatefulWidget {
  const SavingsCarousel({super.key});

  @override
  ConsumerState<SavingsCarousel> createState() => _SavingsCarouselState();
}

class _SavingsCarouselState extends ConsumerState<SavingsCarousel> {
  int _getTotalBalance(List<Saving> debits) {
    return debits
            .map((e) => e.amount)
            .reduce((value, element) => value! + element!)!;
  }
  
  @override
  Widget build(BuildContext context) {
    final asyncSavings = ref.watch(savingProvider);
    return switch(asyncSavings) {
    AsyncData(:final value) => Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: ExpansionTile(
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        title: Text(
          "Tài khoản tiết kiệm (${value.length})",
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        subtitle: value.isEmpty
                  ? null
                  : Row(
                      children: [
                        Text(
                          NumberFormat.decimalPattern().format(_getTotalBalance(value)),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigoAccent.shade700,
                          ),
                        ),
                        const Text(
                          "VND", 
                          style: TextStyle(
                            fontSize: 12
                          ),
                        ),
                      ],
                    ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        childrenPadding: const EdgeInsets.all(5.0),
        children: [
          ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) => _SavingListTile(saving: value[index]), 
            separatorBuilder: ((context, index) => const Divider()), 
            itemCount: value.length,
          )
        ],
      ),
    ),
    AsyncError(:final error) => Text("$error"),
    _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _SavingListTile extends StatelessWidget {
  final Saving saving;
  const _SavingListTile({Key? key, required this.saving}) : super(key: key);

    
  _savingDetail(Saving saving) {

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _savingDetail(saving),
      child: ListTile(
        title: Text(
          "${saving.title}"
        ),
        subtitle: Text(
          NumberFormat.decimalPattern().format(saving.amount),
          style: const TextStyle(
    
          ),
        ),
        trailing: saving.goal == null
        ? null 
        : Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${saving.goal?.title}, ${DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(saving.goal!.deadline!)}"),
            Text("${saving.amount}/${saving.goal!.targetAmount}"),
          ],
        )
      ),
    );
  }
}
