import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';

class CustomStepperItem extends StatelessWidget {
  final String title;
  final bool active;
  final TextStyle? textStyle;

  const CustomStepperItem({
    super.key,
    required this.title,
    required this.active,
    this.textStyle = kTestStyleRegularText14,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 15,
          height: 15,
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
        SizedBox(
          height: 40,
          child: Text(title, style: textStyle, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
