import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_response.dart';

class AgendaVisitaManterControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData dataAgendadaData;
  late final CustomFormFieldData dataAgendadaHora;
  late final CustomFormFieldData duracaoPrevista;
  late final CustomFormFieldData objetivo;
  late final CustomFormFieldData observacao;

  AgendaVisitaManterControllers() {
    dataAgendadaData = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: null,
      hintText: 'Data',
      inputFormatters: [
        MaskTextInputFormatter(
          mask: '##/##/####',
          filter: {'#': RegExp(r'[0-9]')},
        ),
      ],
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe a Data Agendada.'
          : null,
    );
    dataAgendadaHora = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: null,
      hintText: 'Hora',
      inputFormatters: [
        MaskTextInputFormatter(mask: '##:##', filter: {'#': RegExp(r'[0-9]')}),
      ],
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe a Hora Agendada.'
          : null,
    );

    duracaoPrevista = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      hintText: 'Duração Prevista',
      labelText: null,
    );
    objetivo = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Objetivo',
    );
    observacao = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Observação',
    );
  }

  void dispose() {
    dataAgendadaData.controller.dispose();
    dataAgendadaData.focusNode.dispose();
    dataAgendadaHora.controller.dispose();
    dataAgendadaHora.focusNode.dispose();
    duracaoPrevista.controller.dispose();
    duracaoPrevista.focusNode.dispose();
    objetivo.controller.dispose();
    objetivo.focusNode.dispose();
    observacao.controller.dispose();
    observacao.focusNode.dispose();
  }

  void updateFormFields(AgendaVisitaResponse? visitaAtual) {
    if (visitaAtual?.dataAgendada != null) {
      dataAgendadaData.controller.text = _extractDate(
        visitaAtual!.dataAgendada,
      );
      dataAgendadaHora.controller.text = _extractTime(visitaAtual.dataAgendada);
    }
    duracaoPrevista.controller.text =
        visitaAtual?.duracaoPrevista.toString() ?? '';
    objetivo.controller.text = visitaAtual?.objetivo ?? '';
    observacao.controller.text = visitaAtual?.observacao ?? '';
  }

  String _extractDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  String _extractTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
