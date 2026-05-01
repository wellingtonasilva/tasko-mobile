import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';

class CustomStepperItem extends StatelessWidget {
  final String title;
  final bool active;

  CustomStepperItem({required this.title, required this.active});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 15,
          height: 15, // igual ao _line
          alignment: Alignment.center,
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: active ? Colors.orange : Colors.grey[300],
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(title, style: kTestStyleRegularText14),
      ],
    );
  }
}
