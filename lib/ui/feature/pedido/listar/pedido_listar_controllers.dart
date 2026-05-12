import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

class PedidoListarControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData pesquisar;

  PedidoListarControllers() {
    pesquisar = CustomFormFieldData(
      prefixIcon: const Icon(Icons.search),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: null,
      hintText: 'Buscar pedido...',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o nome do pedido.'
          : null,
    );
  }

  void dispose() {
    pesquisar.controller.dispose();
    pesquisar.focusNode.dispose();
  }
}
