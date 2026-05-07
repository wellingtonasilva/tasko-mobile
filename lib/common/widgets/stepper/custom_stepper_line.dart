import 'package:flutter/material.dart';

class CustomStepperLine extends StatelessWidget {
  final double? width;
  const CustomStepperLine({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: width ?? 40,
          height: 15,
          alignment: Alignment.center,
          child: Container(height: 2, color: Colors.grey[300]),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}
