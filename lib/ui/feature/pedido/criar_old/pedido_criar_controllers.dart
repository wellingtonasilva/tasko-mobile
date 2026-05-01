import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

class PedidoCriarControllers {
  final formKey = GlobalKey<FormState>();

  late final CustomFormFieldData observacao;
  late final CustomFormFieldData dataEntregaPrevista;
  late final CustomFormFieldData percentualDesconto;
  late final CustomFormFieldData valorFrete;

  PedidoCriarControllers() {
    observacao = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Observacao',
    );
    dataEntregaPrevista = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Data Entrega Prevista',
    );
    percentualDesconto = CustomFormFieldData(
      controller: TextEditingController(text: '0'),
      focusNode: FocusNode(),
      labelText: 'Desconto (%)',
    );
    valorFrete = CustomFormFieldData(
      controller: TextEditingController(text: '0'),
      focusNode: FocusNode(),
      labelText: 'Valor Frete (R\$)',
    );
  }

  void dispose() {
    observacao.controller.dispose();
    observacao.focusNode.dispose();
    dataEntregaPrevista.controller.dispose();
    dataEntregaPrevista.focusNode.dispose();
    percentualDesconto.controller.dispose();
    percentualDesconto.focusNode.dispose();
    valorFrete.controller.dispose();
    valorFrete.focusNode.dispose();
  }
}
