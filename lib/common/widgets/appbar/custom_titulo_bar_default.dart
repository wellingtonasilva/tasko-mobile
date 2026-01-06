import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_icon_button.dart';

class CustomTituloBarDefault extends StatelessWidget {
  final String title;
  final VoidCallback? onClosePressed;

  const CustomTituloBarDefault({
    super.key,
    required this.title,
    this.onClosePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: kTestStyleBoldText20.copyWith(
            color: kColorStyleSecondinaryDarkDefault,
          ),
        ),
        CustomIconButton(
          icon: const Icon(
            Icons.close,
            color: kColorStyleSecondinaryDarkDefault,
            size: 20,
          ),
          borderRadius: 5,
          buttonSize: 35,
          fillColor: Colors.white,
          hoverColor: Colors.grey.shade200,
          borderColor: kColorStyleSecondinaryLight200,
          borderWidth: 1,
          showLoadingIndicator: false,
          onPressed: () => onClosePressed?.call(),
        ),
      ],
    );
  }
}
