import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';
import 'package:tasko_mobile/domain/condicao_pagamento/response/condicao_pagamento_response.dart';

class CondicaoPagamentoManterControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData descricaoCondicaoPagamento;
  late final CustomFormFieldData condicaoPagamento;

  CondicaoPagamentoManterControllers() {
    descricaoCondicaoPagamento = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Descrição',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe a Descrição da Condição de Pagamento.'
          : null,
    );
    condicaoPagamento = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Condição de Pagamento',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe a Condição de Pagamento.'
          : null,
    );
  }

  void dispose() {
    descricaoCondicaoPagamento.controller.dispose();
    descricaoCondicaoPagamento.focusNode.dispose();
    condicaoPagamento.controller.dispose();
    condicaoPagamento.focusNode.dispose();
  }

  void updateFormFields(CondicaoPagamentoResponse? condicaoPagamento) {
    this.descricaoCondicaoPagamento.controller.text =
        condicaoPagamento?.descricaoCondicaoPagamento ?? '';
    this.condicaoPagamento.controller.text =
        condicaoPagamento?.condicaoPagamento ?? '';
  }
}
