import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';

class CustomLabel extends StatelessWidget {
  final String labelText;

  const CustomLabel({super.key, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        labelText,
        style: kTestStyleMediumText14.copyWith(
          color: kColorStyleSecondinaryLight400,
        ),
      ),
    );
  }
}
