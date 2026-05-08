import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

class TerritorioListarControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData pesquisarTerritorio;

  TerritorioListarControllers() {
    pesquisarTerritorio = CustomFormFieldData(
      prefixIcon: const Icon(Icons.search),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: null,
      hintText: 'Buscar território...',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o nome do território.'
          : null,
    );
  }

  void dispose() {
    pesquisarTerritorio.controller.dispose();
    pesquisarTerritorio.focusNode.dispose();
  }
}
