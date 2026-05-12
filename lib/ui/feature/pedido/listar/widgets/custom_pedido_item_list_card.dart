import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/widgets/tags/custom_tag.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_response.dart';
import 'package:tasko_mobile/ui/feature/pedido/listar/widgets/pedido_item_status_helper.dart';

class CustomPedidoItemListCard extends StatelessWidget {
  final PedidoResponse pedido;
  final Function(int id)? onTap;
  final PedidoSyncStatus status;

  const CustomPedidoItemListCard({
    super.key,
    required this.pedido,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(pedido.id);
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
                child: Icon(
                  Icons.receipt,
                  color: kColorStylePrimaryNeutralPaletteDark500,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                'Pedido #${pedido.id}',
                                style: kTestStyleBoldText16,
                              ),
                              if (pedido.descricaoStatusTipo != null)
                                SizedBox(width: 8),
                              if (pedido.descricaoStatusTipo != null)
                                CustomTag(
                                  text: pedido.descricaoStatusTipo ?? '',
                                  textColor: kColorStyleInformationDark900,
                                  backgroundColor:
                                      kColorStyleInformationLightDefault,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // -- Cliente
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                pedido.nomeFantasiaCliente ?? '',
                                style: kTestStyleMediumText14.copyWith(
                                  color: kColorStyleSecondinaryDark400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'R\$ ${pedido.valorTotal}',
                            style: kTestStyleBoldText16.copyWith(
                              color: kColorStylePrimaryNeutralPaletteDark500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: kColorStyleSecondinaryDark400,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${pedido.dataPedido.day}/${pedido.dataPedido.month}/${pedido.dataPedido.year}',
                                style: kTestStyleMediumText12.copyWith(
                                  color: kColorStyleSecondinaryDark400,
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                color: kColorStyleSecondinaryDark400,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                pedido.nomeVendedor ?? '',
                                style: kTestStyleMediumText12.copyWith(
                                  color: kColorStyleSecondinaryDark400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  color: kColorStyleSecondinaryDark400,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  pedido.dataEntregaPrevista != null
                                      ? '${pedido.dataEntregaPrevista?.day}/${pedido.dataEntregaPrevista?.month}/${pedido.dataEntregaPrevista?.year}'
                                      : 'Não Informada',
                                  style: kTestStyleMediumText12.copyWith(
                                    color: kColorStyleSecondinaryDark400,
                                  ),
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              if (status == PedidoSyncStatus.sincronizado) ...[
                                Icon(
                                  Icons.check_circle,
                                  color: kColorStyleSuccessDark500,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Sincronizado',
                                  style: kTestStyleMediumText12.copyWith(
                                    color: kColorStyleSuccessDark500,
                                  ),
                                ),
                              ] else if (status ==
                                  PedidoSyncStatus.pendente) ...[
                                Icon(
                                  Icons.sync,
                                  color: kColorStyleWarningDark500,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Pendente',
                                  style: kTestStyleMediumText12.copyWith(
                                    color: kColorStyleWarningDark500,
                                  ),
                                ),
                              ] else if (status == PedidoSyncStatus.erro) ...[
                                Icon(
                                  Icons.error,
                                  color: kColorStyleErrorDark500,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Erro de Sync',
                                  style: kTestStyleMediumText12.copyWith(
                                    color: kColorStyleErrorDark500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
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
}
