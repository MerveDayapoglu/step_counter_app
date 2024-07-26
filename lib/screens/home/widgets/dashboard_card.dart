import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:step_counter_app/screens/home/widgets/container_button.dart';
import 'package:step_counter_app/screens/home/widgets/image_container.dart';
import 'package:step_counter_app/screens/home/widgets/text_widget.dart';

// ignore: must_be_immutable
class DashboardCard extends StatelessWidget {
  String steps;
  double miles, calories, duration;
  DashboardCard(this.steps, this.miles, this.calories, this.duration,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: const Color(0xff1D3768),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 150,
                          child: Row(
                            children: [
                              //Adım sayısı text ayarları
                              text(40, steps == "-1" ? "0" : steps),

                              const SizedBox(
                                width: 10,
                              ),

                              // this is for edit icon
                              const Align(
                                alignment: Alignment.topCenter,
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 130,
                  ),
                  Expanded(
                    flex: 1,
                    child: ContainerButton(const Icon(
                      Icons.pause,
                      color: Colors.black87,
                      size: 40,
                    )),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LinearPercentIndicator(
                barRadius: const Radius.circular(15),
                percent: int.parse(steps) / 10000,
                progressColor: Colors.grey.shade600,
                lineHeight: 20,
                animation: true,
              ),
            ),

            const SizedBox(
              height: 40,
            ),

            //Resimlerin gösterildiği alan
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                ImageContainer("assets/images/locations.png",
                    miles.toStringAsFixed(2), "Miles"),
                ImageContainer("assets/images/calories.png",
                    calories.toStringAsFixed(2), "Calories"),
                ImageContainer("assets/images/stopwatch.png",
                    duration.toStringAsFixed(2), "Duration"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
