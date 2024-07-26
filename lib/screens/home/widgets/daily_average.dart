import 'package:flutter/material.dart';
import 'package:step_counter_app/screens/home/widgets/day_count.dart';
import 'package:step_counter_app/screens/home/widgets/text_widget.dart';
import 'package:step_counter_app/service/step_service.dart';

class DailyAverage extends StatefulWidget {
  const DailyAverage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DailyAverageState createState() => _DailyAverageState();
}

class _DailyAverageState extends State<DailyAverage> {
  final StepService _stepService = StepService();
  Map<String, double> weeklySteps = {
    "S": 0.0,
    "M": 0.0,
    "TU": 0.0,
    "W": 0.0,
    "TH": 0.0,
    "FRI": 0.0,
    "SAT": 0.0,
  };

  @override
  void initState() {
    super.initState();
    _loadWeeklySteps();
  }

  void _loadWeeklySteps() {
    final weeklyStepsData = _stepService.getWeeklySteps();
    setState(() {
      weeklySteps =
          weeklyStepsData.map((day, steps) => MapEntry(day, steps.toDouble()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.23,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: const Color(0xff1D3768),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: text(20, "Daily Average"),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: weeklySteps.entries.map((entry) {
                  final day = entry.key;
                  final steps = entry.value == -1 ? 0 : entry.value;
                  final percentage = steps / 10000;
                  // ignore: avoid_print
                  print("$day $steps");
                  return CircularDay(day, percentage, _getColorForDay(day));
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForDay(String day) {
    switch (day) {
      case "S":
        return Colors.red;
      case "M":
        return Colors.cyan;
      case "TU":
        return Colors.teal;
      case "W":
        return Colors.amber;
      case "TH":
        return Colors.green;
      case "FRI":
        return Colors.indigo;
      case "SAT":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
