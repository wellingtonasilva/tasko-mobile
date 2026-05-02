// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_action_icon_button.dart';

class CustomActionViewIconButton extends StatelessWidget {
  final Function()? onPressed;

  const CustomActionViewIconButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomActionIconButton(
      icon: Icon(
        Icons.visibility,
        size: 20,
        color: kColorStylePrimaryNeutralPaletteLightDefault,
      ),
      color: kColorStyleSuccessDarkDefault,
      onPressed: onPressed,
    );
  }
}
