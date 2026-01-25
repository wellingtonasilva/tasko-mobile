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

@Preview(name: 'Custom Dashboard Mini Money Item')
Widget customDashboardCardDefaultPreview() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: CustomDashboardCardDefault(
      title: 'Total Sales',
      value: '\$121,412',
      icon: Image.asset(
        'assets/images/pos_icon_moneys.png',
        color: kColorStylePrimaryNeutralPaletteDark500,
        width: 35,
      ),
      iconBackgroundColor: kColorStylePrimaryNeutralPaletteLight100,
    ),
  );
}

@Preview(name: 'Custom Dashboard Mini People Item')
Widget customDashboardCardPeopleDefaultPreview() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: CustomDashboardCardDefault(
      title: 'Total Customers',
      value: '4,324',
      icon: Image.asset(
        'assets/images/pos_icon_people.png',
        color: kColorStyleInformationDarkDefault,
        width: 35,
      ),
      iconBackgroundColor: kColorStyleInformationLightDefault,
    ),
  );
}

@Preview(name: 'Custom Dashboard Mini Food Item')
Widget customDashboardCardFoodDefaultPreview() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: CustomDashboardCardDefault(
      title: 'Total Order',
      value: '5,021',
      icon: Image.asset(
        'assets/images/pos_icon_bowl_food_fill.png',
        color: kColorStyleErrorDark500,
        width: 35,
      ),
      iconBackgroundColor: kColorStyleErrorLight100,
    ),
  );
}

@Preview(name: 'Custom Dashboard Mini Box Item')
Widget customDashboardCardBoxDefaultPreview() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: CustomDashboardCardDefault(
      title: 'Total Tip',
      value: '\$1,412',
      icon: Image.asset(
        'assets/images/pos_icon_money_tick.png',
        color: kColorStyleSuccessDark500,
        width: 35,
      ),
      iconBackgroundColor: kColorStyleSuccessLightefault,
    ),
  );
}

@Preview(name: 'Custom Dashboard Mini Document Item')
Widget customDashboardCardDocumentDefaultPreview() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: CustomDashboardCardDefault(
      title: 'Total Products',
      value: '150',
      icon: Image.asset(
        'assets/images/pos_icon_box.png',
        color: kColorStylePrimaryNeutralPaletteDark500,
        width: 35,
      ),
      iconBackgroundColor: kColorStylePrimaryNeutralPaletteLight100,
    ),
  );
}

@Preview(name: 'Custom Dashboard Mini Direct Box Item')
Widget customDashboardCardDirectBoxDefaultPreview() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: CustomDashboardCardDefault(
      title: 'Total Category Product',
      value: '06',
      icon: Image.asset(
        'assets/images/pos_icon_directbox_default.png',
        color: kColorStyleSuccessDark500,
        width: 35,
      ),
      iconBackgroundColor: kColorStyleSuccessLightefault,
    ),
  );
}

@Preview(name: 'Custom Dashboard Mini Document Text Item')
Widget customDashboardCardDocumentTextDefaultPreview() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: CustomDashboardCardDefault(
      title: 'Purchase Invoice',
      value: '543',
      icon: Image.asset(
        'assets/images/pos_icon_document_text.png',
        color: kColorStyleInformationDarkDefault,
        width: 35,
      ),
      iconBackgroundColor: kColorStyleInformationLightDefault,
    ),
  );
}
