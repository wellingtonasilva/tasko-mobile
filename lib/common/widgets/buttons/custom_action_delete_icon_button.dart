import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_action_icon_button.dart';

class CustomActionDeleteIconButton extends StatelessWidget {
  final Function()? onPressed;

  const CustomActionDeleteIconButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomActionIconButton(
      icon: Icon(
        Icons.delete,
        size: 20,
        color: kColorStylePrimaryNeutralPaletteLightDefault,
      ),
      color: kColorStyleErrorDarkDefault,
      onPressed: onPressed,
    );
  }
}
