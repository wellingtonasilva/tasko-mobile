import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/widgets/tags/custom_tag.dart';

class CustomTagPendente extends StatelessWidget {
  final String text;
  const CustomTagPendente({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return CustomTag(
      text: text,
      textColor: kColorStylePrimary200,
      backgroundColor: kColorStyleWarning600,
    );
  }
}
