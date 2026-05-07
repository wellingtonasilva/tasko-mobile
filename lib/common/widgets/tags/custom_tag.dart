import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';

class CustomTag extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;

  const CustomTag({
    super.key,
    required this.text,
    required this.backgroundColor,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: kTestStyleRegularText12.copyWith(color: textColor),
      ),
    );
  }
}
