import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';

class CustomDashboardCard extends StatelessWidget {
  final Icon icon;
  final String title;
  final String valor;

  const CustomDashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.all(8.0), child: icon),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5.0),
                Text(valor, style: kTestStyleBoldText36),
                const SizedBox(height: 8.0),
                Text(
                  title,
                  style: kTestStyleBoldText12.copyWith(
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

@Preview(name: 'Custom Dashboard Card')
Widget customDashboardCardPreview() {
  return CustomDashboardCard(
    icon: const Icon(Icons.account_circle, size: 40.0),
    title: 'Total Users',
    valor: '1,234',
  );
}
