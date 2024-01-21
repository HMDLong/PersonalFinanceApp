import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class GaugeIndicator extends StatelessWidget {
  final double value;
  final double min;
  final double max;

  const GaugeIndicator({
    Key? key, 
    required this.value, 
    required this.min,
    required this.max,
  }) : super(key: key);

  Color getProgressBarColor() {
    final sub = max - min;
    if(value <= min+sub*0.5) {
      return Colors.green;
    } else if(value <= min+sub*0.75) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sub = max - min;
    return SizedBox(
      height: 50,
      width: 50,
      child: RadialGauge(
        // radius: 100.0,
        value: value > max ? max : value, 
        axis: GaugeAxis(
          progressBar: GaugeRoundedProgressBar(
            color: getProgressBarColor(),
          ),
          style: const GaugeAxisStyle(
            thickness: 5.0,
            background: Color.fromARGB(255, 144, 180, 238),
            segmentSpacing: 3.0,
            cornerRadius: Radius.circular(5.0),
          ),
          pointer: const GaugePointer.circle(radius: 5.0, color: Colors.black54),
          degrees: 260,
          min: min,
          max: max,
          segments: [
            GaugeSegment(from: min, to: min + sub*0.5),
            GaugeSegment(from: min + sub*0.5, to: min + sub*0.75),
            GaugeSegment(from: min + sub*0.75, to: max),
          ]
        ),
      ),
    );
  }
}