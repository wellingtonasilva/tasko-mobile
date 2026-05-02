// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';

class CustomCategoryButton extends StatelessWidget {
  final String filename;
  final String title;
  final String subtitle;
  final bool selected;

  const CustomCategoryButton({
    super.key,
    required this.filename,
    required this.title,
    required this.subtitle,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 174,
      height: 77,
      decoration: BoxDecoration(
        color: kColorStylePrimaryNeutralPaletteLightDefault,
        border: Border.all(
          color: selected
              ? kColorStylePrimaryNeutralPaletteDarkDefault
              : kColorStylePrimaryNeutralPaletteLightDefault,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: SvgPicture.asset(
                filename,
                colorFilter: ColorFilter.mode(
                  selected
                      ? kColorStylePrimaryNeutralPaletteDarkDefault
                      : kColorStyleSecondinaryLight400,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: kTestStyleBoldText14.copyWith(
                    color: selected
                        ? kColorStylePrimaryNeutralPaletteDarkDefault
                        : kColorStyleSecondinaryDarkDefault,
                  ),
                ),
                Text(
                  subtitle,
                  style: kTestStyleRegularText12.copyWith(
                    color: kColorStyleSecondinaryLight400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
