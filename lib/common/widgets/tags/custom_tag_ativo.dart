import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/widgets/tags/custom_tag.dart';

class CustomTagAtivo extends StatelessWidget {
  const CustomTagAtivo({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTag(
      text: 'Ativo',
      textColor: kColorStylePrimaryBasePalette600,
      backgroundColor: kColorStylePrimaryBasePalette80,
    );
  }
}
