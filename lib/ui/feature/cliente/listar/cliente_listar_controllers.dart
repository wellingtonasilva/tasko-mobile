import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

class ClienteListarControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData pesquisar;

  ClienteListarControllers() {
    pesquisar = CustomFormFieldData(
      prefixIcon: const Icon(Icons.search),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: null,
      hintText: 'Buscar cliente...',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o nome do cliente.'
          : null,
    );
  }

  void dispose() {
    pesquisar.controller.dispose();
    pesquisar.focusNode.dispose();
  }
}
