import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_action_icon_button.dart';

class CustomActionIncreaseDecreaseButton extends StatelessWidget {
  final String value;
  final Function()? onIncrease;
  final Function()? onDecrease;

  const CustomActionIncreaseDecreaseButton({
    super.key,
    required this.value,
    this.onIncrease,
    this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        // border: Border.all(color: kColorStyleSecondinaryLight300, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomActionIconButton(
            icon: Icon(
              Icons.remove,
              size: 20,
              color: kColorStylePrimaryNeutralPaletteDark500,
            ),
            onPressed: onDecrease,
            color: kColorStylePrimaryNeutralPaletteLightDefault,
            borderColor: kColorStyleSecondinaryDark200,
          ),
          Text(
            value,
            style: kTestStyleBoldText14.copyWith(
              color: kColorStyleSecondinaryDark600,
            ),
          ),
          CustomActionIconButton(
            icon: Icon(
              Icons.add,
              size: 20,
              color: kColorStylePrimaryNeutralPaletteDark500,
            ),
            onPressed: onIncrease,
            color: kColorStylePrimaryNeutralPaletteLightDefault,
            borderColor: kColorStyleSecondinaryDark200,
          ),
        ],
      ),
    );
  }
}
