// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/providers/local/model_providers/credit_repo.dart';


import '../../../../models/accounts.model.dart';

class CreditCarousel extends StatefulWidget {
  const CreditCarousel({super.key});

  @override
  State<CreditCarousel> createState() => _CreditCarouselState();
}

class _CreditCarouselState extends State<CreditCarousel> {
  int _getTotalBalance(List<Credit> debits) {
    return debits
            .map((e) => e.amount)
            .reduce((value, element) => value! + element!)!;
  }

  @override
  Widget build(BuildContext context) {
    var creditRepo = context.watch<CreditRepository>();
    var credits = creditRepo.getAll();
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: ExpansionTile(
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        title: Text(
          "Tài khoản tín dụng (${credits.length})",
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        subtitle: credits.isEmpty
                  ? null
                  : Row(
                    children: [
                      Text(
                        NumberFormat.decimalPattern().format(_getTotalBalance(credits)),
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
            itemBuilder: (context, index) => _CreditListTile(credit: credits[index]), 
            separatorBuilder: ((context, index) => const Divider()), 
            itemCount: credits.length,
          )
        ],
      ),
    );
  }
}

class _CreditListTile extends StatelessWidget{
  final Credit credit;
  const _CreditListTile({Key? key, required this.credit}) : super(key: key);

    
  _creditDetail(Credit credit) {

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _creditDetail(credit),
      child: ListTile(
        title: Text(
          "${credit.id}"
        ),
        subtitle: Text(
          NumberFormat.decimalPattern().format(credit.amount),
          style: const TextStyle(
    
          ),
        ),
        trailing: RadialGauge(
          value: credit.amount!.toDouble(), 
          axis: GaugeAxis(
            max: credit.amount!.toDouble(),
            segments: [
              GaugeSegment(
                from: 0.0, 
                to: credit.limit!.toDouble() * 0.25
              ),
              GaugeSegment(
                from: credit.limit!.toDouble() * 0.25, 
                to: credit.limit!.toDouble() * 0.5
              ),
              GaugeSegment(
                from: credit.limit!.toDouble() * 0.5, 
                to: credit.limit!.toDouble() * 0.75
              ),
              GaugeSegment(
                from: credit.limit!.toDouble() * 0.75, 
                to: credit.limit!.toDouble()
              ),
            ]
          ),
        ),
      ),
    );
  }
}