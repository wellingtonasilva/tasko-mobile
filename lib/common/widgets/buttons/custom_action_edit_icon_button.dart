import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_action_icon_button.dart';

class CustomActionEditIconButton extends StatelessWidget {
  final Function()? onPressed;

  const CustomActionEditIconButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomActionIconButton(
      icon: Icon(
        Icons.edit,
        size: 20,
        color: kColorStylePrimaryNeutralPaletteDarkDefault,
      ),
      color: kColorStylePrimaryNeutralPaletteLightDefault,
      onPressed: onPressed,
    );
  }
}
