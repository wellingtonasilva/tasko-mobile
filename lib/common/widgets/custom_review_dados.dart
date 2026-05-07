import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';

class CustomReviewDados extends StatelessWidget {
  final String label;
  final String value;

  const CustomReviewDados({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: kTestStyleRegularText14.copyWith(
              color: kColorStyleSecondinaryLight400,
            ),
          ),
        ),
        Text(
          value,
          style: kTestStyleBoldText14.copyWith(
            color: kColorStyleSecondinaryDarkDefault,
          ),
        ),
      ],
    );
  }
}
