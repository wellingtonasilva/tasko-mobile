import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/widgets/tags/custom_tag.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_response.dart';
import 'package:tasko_mobile/ui/feature/agenda_visita/listar/widgets/agenda_visita_custom_status_tag.dart';
import 'package:tasko_mobile/ui/feature/pedido/listar/widgets/pedido_item_status_helper.dart';

class AgendaVisitaListItemCard extends StatelessWidget {
  final AgendaVisitaResponse visita;
  final Function(int id)? onTap;
  final PedidoSyncStatus status;

  const AgendaVisitaListItemCard({
    super.key,
    required this.visita,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(visita.id);
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
              Align(
                alignment: Alignment.topLeft,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: kColorStylePrimaryNeutralPaletteLight100,
                  child: Icon(
                    Icons.calendar_month,
                    color: kColorStylePrimaryNeutralPaletteDark500,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(visita.razaoSocial ?? '', style: kTestStyleBoldText16),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: kColorStyleSecondinaryDark400,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          visita.nomeVendedor ?? '',
                          style: kTestStyleMediumText14.copyWith(
                            color: kColorStyleSecondinaryDark400,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: kColorStyleSecondinaryDark400,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${visita.dataAgendada.day}/${visita.dataAgendada.month}/${visita.dataAgendada.year}',
                              style: kTestStyleMediumText14.copyWith(
                                color: kColorStyleSecondinaryDark400,
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              color: kColorStyleSecondinaryDark400,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${visita.dataAgendada?.hour}:${visita.dataAgendada?.minute}',
                              style: kTestStyleMediumText14.copyWith(
                                color: kColorStyleSecondinaryDark400,
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.hourglass_empty,
                              color: kColorStyleSecondinaryDark400,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              visita?.duracaoPrevista != null
                                  ? '${visita.duracaoPrevista} min'
                                  : '-',
                              style: kTestStyleMediumText14.copyWith(
                                color: kColorStyleSecondinaryDark400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    AgendaVisitaCustomStatusTag(visita: visita),
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
