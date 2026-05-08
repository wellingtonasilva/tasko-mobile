import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

class SupervisorListarControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData pesquisarSupervisor;

  SupervisorListarControllers() {
    pesquisarSupervisor = CustomFormFieldData(
      prefixIcon: const Icon(Icons.search),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: null,
      hintText: 'Buscar supervisor...',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o nome do supervisor.'
          : null,
    );
  }

  void dispose() {
    pesquisarSupervisor.controller.dispose();
    pesquisarSupervisor.focusNode.dispose();
  }
}
