import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';

class CustomConfiguracaoItem extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? prefixIcon;
  final bool showDivider;
  final bool showArrow;

  const CustomConfiguracaoItem({
    super.key,
    required this.label,
    this.value,
    this.prefixIcon,
    this.showDivider = true,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              if (prefixIcon != null) ...[prefixIcon!, SizedBox(width: 8)],
              Expanded(child: Text(label, style: kTestStyleBoldText14)),
              if (value != null)
                Container(
                  decoration: BoxDecoration(
                    color: kColorStyleSecondinaryLight100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: Text(
                      value ?? '',
                      style: kTestStyleBoldText12.copyWith(
                        color: kColorStyleSecondinaryLight400,
                      ),
                    ),
                  ),
                ),
              SizedBox(width: 20),
              Visibility(
                visible: showArrow,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color: kColorStyleInformationDark900,
                ),
              ),
            ],
          ),
        ),
        if (showDivider) ...[
          Divider(color: Colors.grey.withOpacity(0.15), thickness: 1),
        ],
      ],
    );
  }
}
