import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

class PedidoAdicionarClienteControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData pesquisaCliente;

  PedidoAdicionarClienteControllers() {
    pesquisaCliente = CustomFormFieldData(
      prefixIcon: const Icon(Icons.search),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Pesquisar cliente',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o nome do cliente.'
          : null,
    );
  }

  void dispose() {
    pesquisaCliente.controller.dispose();
    pesquisaCliente.focusNode.dispose();
  }
}
