import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

class PedidoCriarProdutoControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData pesquisaProduto;

  PedidoCriarProdutoControllers() {
    pesquisaProduto = CustomFormFieldData(
      prefixIcon: const Icon(Icons.search),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Pesquisar produto',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o nome do produto.'
          : null,
    );
  }

  void dispose() {
    pesquisaProduto.controller.dispose();
    pesquisaProduto.focusNode.dispose();
  }
}
