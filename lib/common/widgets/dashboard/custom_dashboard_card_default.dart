import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';

class CustomDashboardCardDefault extends StatelessWidget {
  final String title;
  final String value;
  final Image icon;
  final Color? iconBackgroundColor;

  const CustomDashboardCardDefault({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kColorStyleSecondinaryDark200, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    title,
                    style: kTestStyleRegularText14.copyWith(
                      color: kColorStyleSecondinaryLight400,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(value, style: kTestStyleBoldText24),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                width: 60,
                decoration: BoxDecoration(
                  color:
                      iconBackgroundColor ??
                      kColorStylePrimaryNeutralPaletteLight100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: icon,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@Preview(name: 'Custom Dashboard Mini Item')
Widget customDashboardMiniItemPreview() {
  return CustomDashboardCardDefault(
    title: 'Total Sales',
    value: '\$121,412',
    icon: Image.asset(
      'assets/images/pos_icon_setting.png',
      color: kColorStyleSecondinaryDarkDefault,
      width: 24,
    ),
  );
}
