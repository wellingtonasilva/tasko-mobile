import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

class PedidoAdicionarControllers {
  final formKey = GlobalKey<FormState>();
  late final PageController pageController;
  late final CustomFormFieldData pesquisaCliente;

  PedidoAdicionarControllers() {
    pageController = PageController();
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
    pageController.dispose();
    pesquisaCliente.controller.dispose();
    pesquisaCliente.focusNode.dispose();
  }
}
