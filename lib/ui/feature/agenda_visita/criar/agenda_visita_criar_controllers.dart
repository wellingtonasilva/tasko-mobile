import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

class AgendaVisitaCriarControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData dataAgendadaData;
  late final CustomFormFieldData dataAgendadaHora;
  late final CustomFormFieldData duracaoPrevista;
  late final CustomFormFieldData objetivo;
  late final CustomFormFieldData observacao;

  AgendaVisitaCriarControllers() {
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
}
