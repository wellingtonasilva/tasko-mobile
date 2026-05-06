import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

class VendedorListarControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData pesquisarVendedor;

  VendedorListarControllers() {
    pesquisarVendedor = CustomFormFieldData(
      prefixIcon: const Icon(Icons.search),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: null,
      hintText: 'Buscar vendedor...',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o nome do vendedor.'
          : null,
    );
  }

  void dispose() {
    pesquisarVendedor.controller.dispose();
    pesquisarVendedor.focusNode.dispose();
  }
}
