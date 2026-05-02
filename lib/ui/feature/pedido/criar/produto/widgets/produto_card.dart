import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_action_icon_button.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_action_increase_decrease_button.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';

class ProdutoCard extends StatefulWidget {
  final ProdutoResponse produto;
  final bool isSelected;
  final Function()? onTap;

  const ProdutoCard({
    super.key,
    required this.produto,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<ProdutoCard> createState() => _ProdutoCardState();
}

class _ProdutoCardState extends State<ProdutoCard> {
  int quantidade = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? kColorStylePrimaryNeutralPaletteDark500
                  : Colors.grey.shade300,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.produto.nomeProduto, style: kTestStyleBoldText16),
                  SizedBox(height: 4),
                  Text(
                    "Código: ${widget.produto.codigoProduto ?? 'N/A'}",
                    style: kTestStyleRegularText14,
                  ),
                  Text(
                    "Disponível: ${widget.produto.quantidadeDisponivel?.toStringAsFixed(2) ?? 'N/A'}",
                    style: kTestStyleRegularText14,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "R\$ ${widget.produto.precoSugerido?.toStringAsFixed(2) ?? 'N/A'}",
                    style: kTestStyleBoldText16.copyWith(
                      color: kColorStyleSecondinaryDark400,
                    ),
                  ),
                ],
              ),
              if (quantidade > 0)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomActionIncreaseDecreaseButton(
                      value: quantidade.toString(),
                      onIncrease: _addProduto,
                      onDecrease: _removeProduto,
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
                  onPressed: _addProduto,
                  color: kColorStylePrimaryNeutralPaletteDark500,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _addProduto() {
    setState(() {
      quantidade++;
    });
  }

  void _removeProduto() {
    if (quantidade > 0) {
      setState(() {
        quantidade--;
      });
    }
  }
}
