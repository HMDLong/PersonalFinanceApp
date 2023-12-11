import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';

class BudgetsCarousel extends StatefulWidget {
  const BudgetsCarousel({super.key});

  @override
  State<StatefulWidget> createState() => _BudgetsCarouselState();
}

class _BudgetsCarouselState extends State<BudgetsCarousel>{
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [1, 2, 3, 4, 5].map((e) {
          return Container(
            width: 180,
            child: Card(
              child: Text("$e"),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 6,
            ),
          );
        }).toList(),
      ),
    );
  }
}