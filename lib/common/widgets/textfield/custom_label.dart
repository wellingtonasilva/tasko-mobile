import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';

class CustomLabel extends StatelessWidget {
  final String labelText;
  final bool mandatory;

  const CustomLabel({
    super.key,
    required this.labelText,
    this.mandatory = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Text(
            labelText,
            style: kTestStyleMediumText14.copyWith(
              color: kColorStyleSecondinaryLight400,
            ),
          ),
          if (mandatory)
            Text(
              ' *',
              style: kTestStyleMediumText14.copyWith(
                color: kColorStylePrimaryNeutralPaletteDarkDefault,
              ),
            ),
        ],
      ),
    );
  }
}
