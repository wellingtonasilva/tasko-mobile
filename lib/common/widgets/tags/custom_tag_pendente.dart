import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/widgets/tags/custom_tag.dart';

class CustomTagPendente extends StatelessWidget {
  const CustomTagPendente({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTag(
      text: 'Pendente',
      textColor: kColorStylePrimary200,
      backgroundColor: kColorStyleWarning600,
    );
  }
}
