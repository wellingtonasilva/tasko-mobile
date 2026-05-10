import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

class ProdutoListarControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData pesquisar;

  ProdutoListarControllers() {
    pesquisar = CustomFormFieldData(
      prefixIcon: const Icon(Icons.search),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: null,
      hintText: 'Buscar produto...',
    );
  }

  void dispose() {
    pesquisar.controller.dispose();
    pesquisar.focusNode.dispose();
  }
}
