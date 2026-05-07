import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/widgets/tags/custom_tag.dart';

class CustomTagInativo extends StatelessWidget {
  const CustomTagInativo({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTag(
      text: 'Inativo',
      textColor: kColorStyleErrorLight300,
      backgroundColor: kColorStyleErrorLight100,
    );
  }
}
