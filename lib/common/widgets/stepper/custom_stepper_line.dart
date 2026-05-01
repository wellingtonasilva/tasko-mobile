import 'package:flutter/material.dart';

class CustomStepperLine extends StatelessWidget {
  const CustomStepperLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 10,
          alignment: Alignment.center,
          child: Container(height: 2, color: Colors.grey[300]),
        ),
        SizedBox(height: 25),
      ],
    );
  }
}
