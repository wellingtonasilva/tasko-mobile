import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';

class ClienteCard extends StatelessWidget {
  final ClienteResponse cliente;
  final bool isSelected;
  final Function()? onTap;

  const ClienteCard({
    super.key,
    required this.cliente,
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
              Text(cliente.nomeFantasia ?? '-', style: kTestStyleBoldText16),
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
