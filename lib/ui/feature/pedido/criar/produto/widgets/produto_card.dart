import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';

class ProdutoCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? kColorStylePrimaryNeutralPaletteDark500
                  : Colors.grey.shade300,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(produto.nomeProduto, style: kTestStyleBoldText16),
              SizedBox(height: 4),
              Text("Último pedido: R\$ 1.000", style: kTestStyleRegularText14),
              Text("Limite: R\$ 5.000", style: kTestStyleRegularText14),
            ],
          ),
        ),
      ),
    );
  }
}
