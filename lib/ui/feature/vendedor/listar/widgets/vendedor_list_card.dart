import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/widgets/tags/custom_tag_ativo.dart';
import 'package:tasko_mobile/common/widgets/tags/custom_tag_inativo.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';

class VendedorListCard extends StatelessWidget {
  final VendedorResponse vendedor;
  final bool isSelected;
  final Function()? onTap;

  const VendedorListCard({
    super.key,
    required this.vendedor,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                radius: 28,
                backgroundColor: kColorStylePrimaryNeutralPaletteLight100,
                child: Text(
                  getIniciais(vendedor.nomeVendedor ?? ''),
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
                    Text(
                      vendedor.nomeVendedor ?? '-',
                      style: kTestStyleBoldText16,
                    ),
                    SizedBox(height: 4),
                    Text(
                      vendedor.codigoVendedor ?? '-',
                      style: kTestStyleRegularText14,
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            vendedor.numeroTelefone ?? '-',
                            style: kTestStyleRegularText14.copyWith(
                              color: kColorStyleSecondinaryLight400,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        vendedor.auditoria?.indicadorAtivo == true
                            ? CustomTagAtivo()
                            : CustomTagInativo(),
                        SizedBox(width: 16),
                      ],
                    ),
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
