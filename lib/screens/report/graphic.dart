// ignore_for_file: curly_braces_in_flow_control_structures, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:step_counter_app/service/step_service.dart';

class WeeklyStepsChart extends StatelessWidget {
  final StepService stepService = StepService();

  WeeklyStepsChart({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, int> weeklySteps = stepService.getWeeklySteps();

    return Container(
      padding: const EdgeInsets.all(30),
      margin: const EdgeInsets.only(top: 50),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: const Color(0xff224A88),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 10000,
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  switch (value.toInt()) {
                    case 0:
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: const Text(
                          'S',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      );
                    case 1:
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: const Text(
                          'M',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      );
                    case 2:
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: const Text(
                          'TU',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      );
                    case 3:
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: const Text(
                          'W',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      );
                    case 4:
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: const Text(
                          'TH',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      );
                    case 5:
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: const Text(
                          'FRI',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      );
                    case 6:
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: const Text(
                          'SAT',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      );
                    default:
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: const Text(''),
                      );
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(
                    '${(value / 1000).toStringAsFixed(1)}k',
                    style: const TextStyle(color: Colors.white, fontSize: 8),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(
                    '${(value / 1000).toStringAsFixed(1)}k',
                    style: const TextStyle(color: Colors.white, fontSize: 8),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
            border: Border.all(color: Colors.white),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                weeklySteps.length,
                (index) => FlSpot(
                  index.toDouble(),
                  weeklySteps.values.elementAt(index).toDouble(),
                ),
              ),
              isCurved: true,
              color: Colors.grey,
              barWidth: 4,
              isStrokeCapRound: true,
              preventCurveOverShooting: true,
              belowBarData: BarAreaData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
