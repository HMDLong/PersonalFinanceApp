import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/providers/local/model_providers/savings_repo.dart';

import '../../../../models/accounts.model.dart';

class SavingsCarousel extends StatefulWidget {
  const SavingsCarousel({super.key});

  @override
  State<SavingsCarousel> createState() => _SavingsCarouselState();
}

class _SavingsCarouselState extends State<SavingsCarousel> {
  int _getTotalBalance(List<Saving> debits) {
    return debits
            .map((e) => e.amount)
            .reduce((value, element) => value! + element!)!;
  }
  
  @override
  Widget build(BuildContext context) {
    var savingRepo = context.watch<SavingRepository>();
    var savings = savingRepo.getAll();
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: ExpansionTile(
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        title: Text(
          "Tài khoản tiết kiệm (${savings.length})",
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        subtitle: savings.isEmpty
                  ? null
                  : Row(
                      children: [
                        Text(
                          NumberFormat.decimalPattern().format(_getTotalBalance(savings)),
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
            itemBuilder: (context, index) => _SavingListTile(saving: savings[index]), 
            separatorBuilder: ((context, index) => const Divider()), 
            itemCount: savings.length,
          )
        ],
      ),
    );
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
        : RadialGauge(
          value: saving.amount!.toDouble(), 
          axis: GaugeAxis(
            max: saving.goal!.targetAmount!.toDouble(),
            segments: [
              GaugeSegment(
                from: 0.0, 
                to: saving.goal!.targetAmount!.toDouble() * 0.25
              ),
              GaugeSegment(
                from: saving.goal!.targetAmount!.toDouble() * 0.25, 
                to: saving.goal!.targetAmount!.toDouble() * 0.5
              ),
              GaugeSegment(
                from: saving.goal!.targetAmount!.toDouble() * 0.5, 
                to: saving.goal!.targetAmount!.toDouble() * 0.75
              ),
              GaugeSegment(
                from: saving.goal!.targetAmount!.toDouble() * 0.75, 
                to: saving.goal!.targetAmount!.toDouble()
              ),
            ]
          ),
        ),
      ),
    );
  }
}
