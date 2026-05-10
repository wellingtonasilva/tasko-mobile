import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/widgets/tags/custom_tag_ativo.dart';
import 'package:tasko_mobile/common/widgets/tags/custom_tag_inativo.dart';

class CustomSimpleItemListCard extends StatelessWidget {
  final int id;
  final String title;
  final String subtitle;
  final Function(int id)? onTap;
  final bool? indicadorAtivo;

  const CustomSimpleItemListCard({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.indicadorAtivo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(id);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            color: kColorStylePrimary0,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: kColorStylePrimaryNeutralPaletteLight100,
                child: Text(
                  getIniciais(title),
                  style: kTestStyleBoldText16.copyWith(
                    color: kColorStylePrimaryNeutralPaletteDark500,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: kTestStyleBoldText16),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(subtitle, style: kTestStyleRegularText14),
                        ),
                        SizedBox(width: 16),
                        if (indicadorAtivo != null)
                          indicadorAtivo == true
                              ? CustomTagAtivo()
                              : CustomTagInativo(),
                        SizedBox(width: 16),
                      ],
                    ),

                    SizedBox(height: 4),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Icon(
                Icons.keyboard_arrow_right,
                color: kColorStyleInformationDark900,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getIniciais(String name) {
    final trimmed = name.trim();

    if (trimmed.isEmpty) return "";

    final words = trimmed.split(RegExp(r'\s+'));

    final initials = words
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

    return initials;
  }
}
