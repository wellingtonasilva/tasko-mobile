import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/widgets/tags/custom_tag.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_response.dart';

class AgendaVisitaCustomStatusTag extends StatelessWidget {
  final AgendaVisitaResponse visita;

  const AgendaVisitaCustomStatusTag({super.key, required this.visita});

  @override
  Widget build(BuildContext context) {
    return switch (visita.descricaoVisitaStatus) {
      'Confirmada' => CustomTag(
        text: visita.descricaoVisitaStatus ?? '',
        backgroundColor: kColorStyleAgendaVisitaSuccessBg,
        textColor: kColorStyleAgendaVisitaSuccessText,
      ),
      'Em atendimento' => CustomTag(
        text: visita.descricaoVisitaStatus ?? '',
        backgroundColor: kColorStyleInformationLight200,
        textColor: kColorStyleInformationDarkDefault,
      ),
      'Concluída' => CustomTag(
        text: visita.descricaoVisitaStatus ?? '',
        backgroundColor: kColorStyleAgendaVisitaSuccessBg,
        textColor: kColorStyleAgendaVisitaSuccessText,
      ),
      'Follow-up' => CustomTag(
        text: visita.descricaoVisitaStatus ?? '',
        backgroundColor: kColorStyleAgendaVisitaSuccessBg,
        textColor: kColorStyleAgendaVisitaSuccessText,
      ),
      'Cancelada' => CustomTag(
        text: visita.descricaoVisitaStatus ?? '',
        backgroundColor: kColorStyleAgendaVisitaErrorBg,
        textColor: kColorStyleAgendaVisitaErrorText,
      ),
      'Não realizada' => CustomTag(
        text: visita.descricaoVisitaStatus ?? '',
        backgroundColor: Colors.red,
      ),
      _ => CustomTag(
        text: visita.descricaoVisitaStatus ?? 'Pendente',
        backgroundColor: kColorStyleAgendaVisitaPendingBg,
        textColor: kColorStyleAgendaVisitaPendingText,
      ),
    };
  }
}
