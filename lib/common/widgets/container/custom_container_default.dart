import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';

class CustomContainerDefault extends StatelessWidget {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  const CustomContainerDefault({
    super.key,
    required this.child,
    this.minHeight = 200,
    this.maxHeight = 400,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight, maxHeight: maxHeight),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
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
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: child,
          ),
        ),
      ),
    );
  }
}
