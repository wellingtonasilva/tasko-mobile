import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

class AgendaVisitaListarControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData pesquisar;

  AgendaVisitaListarControllers() {
    pesquisar = CustomFormFieldData(
      prefixIcon: const Icon(Icons.search),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: null,
      hintText: 'Buscar visita...',
      validator: (context, val) =>
          val == null || val.isEmpty ? 'Por favor informe a visita.' : null,
    );
  }

  void dispose() {
    pesquisar.controller.dispose();
    pesquisar.focusNode.dispose();
  }
}
