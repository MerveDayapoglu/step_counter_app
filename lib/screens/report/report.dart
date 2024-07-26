import 'package:flutter/material.dart';
import 'package:step_counter_app/screens/report/graphic.dart';

class Report extends StatelessWidget {
  const Report({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reports',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff0C1E4E),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color(0xff0C1E4E),
              Color(0xff224A88),
            ])),
        child: Column(
          children: [
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  'Weekly Reports',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            //Grafiğin gösterildiği dosya
            Expanded(child: WeeklyStepsChart()), 
          ],
        ),
      ),
    );
  }
}
