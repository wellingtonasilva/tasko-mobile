import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

class ResetarSenhaControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData senha;
  late final CustomFormFieldData repetirSenha;

  ResetarSenhaControllers() {
    senha = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Nova Senha',
      validator: (context, val) =>
          val == null || val.isEmpty ? 'Por favor informe a Nova Senha.' : null,
    );
    repetirSenha = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Repetir Nova Senha',
      validator: (context, val) =>
          val == null || val.isEmpty ? 'Por favor informe a Nova Senha.' : null,
    );
  }

  void dispose() {
    senha.controller.dispose();
    senha.focusNode.dispose();
    repetirSenha.controller.dispose();
    repetirSenha.focusNode.dispose();
  }
}
