import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_action_icon_button.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_action_increase_decrease_button.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';

class ProdutoCard extends StatelessWidget {
  final ProdutoResponse produto;
  final double quantidade;
  final Function(double)? onQuantidadeChanged;

  const ProdutoCard({
    super.key,
    required this.produto,
    this.quantidade = 0,
    this.onQuantidadeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: quantidade > 0
                ? kColorStylePrimaryNeutralPaletteDark500
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(produto.nomeProduto ?? '-', style: kTestStyleBoldText16),
                  SizedBox(height: 4),
                  Text(
                    "Código: ${produto.codigoProduto ?? 'N/A'}",
                    style: kTestStyleRegularText14,
                  ),
                  Text(
                    "Disponível: ${produto.quantidadeDisponivel?.toStringAsFixed(2) ?? 'N/A'}",
                    style: kTestStyleRegularText14,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "R\$ ${produto.precoSugerido?.toStringAsFixed(2) ?? 'N/A'}",
                    style: kTestStyleBoldText16.copyWith(
                      color: kColorStyleSecondinaryDark400,
                    ),
                  ),
                ],
              ),
            ),
            if (quantidade > 0)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomActionIncreaseDecreaseButton(
                    value: quantidade.toInt().toString(),
                    onIncrease: () => onQuantidadeChanged?.call(quantidade + 1),
                    onDecrease: () => onQuantidadeChanged?.call(quantidade - 1),
                  ),
                ],
              ),
            if (quantidade == 0)
              CustomActionIconButton(
                icon: Icon(
                  Icons.add,
                  size: 20,
                  color: kColorStylePrimaryNeutralPaletteLightDefault,
                ),
                onPressed: () => onQuantidadeChanged?.call(1),
                color: kColorStylePrimaryNeutralPaletteDark500,
              ),
          ],
        ),
      ),
    );
  }
}
