import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';

class CustomButtonDisable extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final double height;

  const CustomButtonDisable({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: kColorStyleSecondinaryLight100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kColorStyleSecondinaryLight200, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leadingIcon != null) ...[
                  Icon(
                    leadingIcon,
                    color: kColorStyleSecondinaryLight300,
                    size: 23,
                  ),
                  const SizedBox(width: 16),
                ],
                Text(
                  label,
                  style: kTestStyleBoldText16.copyWith(
                    color: kColorStyleSecondinaryLight300,
                  ),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 16),
                  Icon(
                    trailingIcon,
                    color: kColorStyleSecondinaryLight300,
                    size: 23,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
