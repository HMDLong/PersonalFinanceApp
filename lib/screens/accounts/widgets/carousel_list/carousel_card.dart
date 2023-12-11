import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/models/accounts.model.dart';
import 'package:saving_app/providers/local/model_providers/debit_repo.dart';

class CarouselCard extends StatelessWidget {
  final String id;
  const CarouselCard({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    var debit = context.select<DebitRepository, Debit>((repo) => repo.getAt(id)!);
    return Container(
      margin: const EdgeInsets.all(5.0),
      width: 280.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0.0, 2.0),
            // blurRadius: 6.0,
          )
        ]
      ),
      child: GestureDetector(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            const SizedBox(
              width: 280.0,
              height: 200.0,
            ),
            Positioned(
              bottom: 10.0,
              left: 10.0,
              child: Column(
                children: [
                  Text(debit.id!),
                  const SizedBox(height: 10,),
                  Text("${NumberFormat.decimalPattern().format(debit.amount)} VND"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}