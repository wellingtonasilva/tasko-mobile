import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

class ConfiguracaoControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData pesquisarConfiguracao;

  ConfiguracaoControllers() {
    pesquisarConfiguracao = CustomFormFieldData(
      prefixIcon: const Icon(Icons.search),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: null,
      hintText: 'Buscar configuração...',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o nome da configuração.'
          : null,
    );
  }

  void dispose() {
    pesquisarConfiguracao.controller.dispose();
    pesquisarConfiguracao.focusNode.dispose();
  }
}
