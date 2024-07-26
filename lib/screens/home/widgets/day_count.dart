import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:step_counter_app/screens/home/widgets/text_widget.dart';

// ignore: must_be_immutable
class CircularDay extends StatelessWidget {
  String day;
  double percentage;
  Color colors;

  CircularDay(this.day, this.percentage, this.colors, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.10,
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: 20.0,
              lineWidth: 2.0,
              animation: true,
              percent: percentage,
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: colors,
            ),
            const SizedBox(
              height: 5,
            ),
            text(14, day)
          ],
        ),
      ),
    );
  }
}
