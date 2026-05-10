import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/widgets/tags/custom_tag.dart';
import 'package:tasko_mobile/common/widgets/tags/custom_tag_ativo.dart';
import 'package:tasko_mobile/common/widgets/tags/custom_tag_inativo.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';

class CustomProdutoItemCard extends StatelessWidget {
  final ProdutoResponse produto;
  final Function(ProdutoResponse produto)? onTap;

  const CustomProdutoItemCard({super.key, required this.produto, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(produto);
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
                  getIniciais(produto.nomeProduto ?? ''),
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            produto.nomeProduto ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: kTestStyleBoldText16,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'R\$ ${produto.precoSugerido?.toStringAsFixed(2).replaceAll('.', ',') ?? '0,00'}',
                          style: kTestStyleBoldText16.copyWith(
                            color: kColorStylePrimaryNeutralPaletteDark500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            getGrupoComSubgrupo(),
                            style: kTestStyleRegularText12,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          'Estoque',
                          style: kTestStyleBoldText14.copyWith(
                            color: kColorStyleSecondinaryDark400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        CustomTag(
                          text: produto.descricaoUnidadeMedidaCodigo ?? '',
                          backgroundColor: kColorStyleSecondinaryLight200,
                          textColor: kColorStyleSuccessDark900,
                        ),
                        Expanded(child: SizedBox(width: 8)),
                        Text(
                          produto.quantidadeDisponivel?.toStringAsFixed(2) ??
                              '0',
                          style: kTestStyleBoldText16,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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

  String getGrupoComSubgrupo() {
    if (produto.descricaoSubgrupo != null &&
        produto.descricaoSubgrupo!.isNotEmpty) {
      return '${produto.descricaoGrupo} > ${produto.descricaoSubgrupo}';
    }
    return produto.descricaoGrupo ?? '';
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
