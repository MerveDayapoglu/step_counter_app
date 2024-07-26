import 'package:flutter/material.dart';
import 'package:step_counter_app/screens/home/widgets/text_widget.dart';

// ignore: must_be_immutable
class ImageContainer extends StatelessWidget {
  String imagePath, number, textTitle;
  ImageContainer(this.imagePath, this.number, this.textTitle, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.12,
      width: MediaQuery.of(context).size.width * 0.29,
      child: Column(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.fill,
              ),
            ),
          ),
          // text
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: text(16, number),
          ),

          text(12, textTitle),
        ],
      ),
    );
  }
}
