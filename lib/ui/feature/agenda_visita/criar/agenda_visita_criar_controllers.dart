import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

class AgendaVisitaCriarControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData dataAgendadaData;
  late final CustomFormFieldData dataAgendadaHora;
  late final CustomFormFieldData vendedorId;
  late final CustomFormFieldData clienteId;
  late final CustomFormFieldData agendaVisitaStatusId;
  late final CustomFormFieldData duracaoPrevista;
  late final CustomFormFieldData objetivo;
  late final CustomFormFieldData observacao;

  AgendaVisitaCriarControllers() {
    dataAgendadaData = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Data Agendada - Data',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe a Data Agendada.'
          : null,
    );
    dataAgendadaHora = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Data Agendada - Hora',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe a Hora Agendada.'
          : null,
    );
    vendedorId = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Vendedor',
      validator: (context, val) =>
          val == null || val.isEmpty ? 'Por favor informe o Vendedor.' : null,
    );
    clienteId = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Cliente',
      validator: (context, val) =>
          val == null || val.isEmpty ? 'Por favor informe o Cliente.' : null,
    );
    agendaVisitaStatusId = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Status da Visita',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o Status da Visita.'
          : null,
    );
    duracaoPrevista = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Duração Prevista (minutos)',
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
    vendedorId.controller.dispose();
    vendedorId.focusNode.dispose();
    clienteId.controller.dispose();
    clienteId.focusNode.dispose();
    agendaVisitaStatusId.controller.dispose();
    agendaVisitaStatusId.focusNode.dispose();
    duracaoPrevista.controller.dispose();
    duracaoPrevista.focusNode.dispose();
    objetivo.controller.dispose();
    objetivo.focusNode.dispose();
    observacao.controller.dispose();
    observacao.focusNode.dispose();
  }
}
