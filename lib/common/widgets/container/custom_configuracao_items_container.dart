import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';

class CustomConfiguracaoItemsContainer extends StatelessWidget {
  final String label;
  final List<Widget> children;
  final Color? backgroundColor;

  const CustomConfiguracaoItemsContainer({
    super.key,
    required this.label,
    required this.children,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label.toUpperCase(), style: kTestStyleMediumText14),
        ),
        SizedBox(height: 5),
        Container(
          width: double.infinity,

          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [SizedBox(height: 5), ...children, SizedBox(height: 5)],
          ),
        ),
      ],
    );
  }
}
