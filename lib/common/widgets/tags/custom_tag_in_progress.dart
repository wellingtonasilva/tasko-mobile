import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/widgets/tags/custom_tag.dart';

class CustomTagInProgress extends StatelessWidget {
  const CustomTagInProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTag(
      text: 'Em Progresso',
      textColor: kColorStyleInformation600,
      backgroundColor: kColorStyleInformation100,
    );
  }
}
