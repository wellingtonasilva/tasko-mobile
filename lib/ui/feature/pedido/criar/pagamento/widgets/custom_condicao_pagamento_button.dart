// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';

class CustomCondicaoPagamentoButton extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback? onPressed;

  const CustomCondicaoPagamentoButton({
    super.key,
    required this.title,
    required this.selected,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          width: 30,
          height: 50,
          decoration: BoxDecoration(
            color: kColorStylePrimaryNeutralPaletteLightDefault,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? kColorStylePrimaryNeutralPaletteDarkDefault
                  : kColorStyleSecondinaryLight300,
              width: selected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    title,
                    style: kTestStyleBoldText14.copyWith(
                      color: selected
                          ? kColorStylePrimaryNeutralPaletteDarkDefault
                          : kColorStyleSecondinaryDarkDefault,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
