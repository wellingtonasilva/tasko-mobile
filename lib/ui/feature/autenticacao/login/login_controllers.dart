import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

class LoginControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData nomeUsuario;
  late final CustomFormFieldData senha;

  LoginControllers() {
    nomeUsuario = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Nome de Usuário',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o Nome de Usuário.'
          : null,
    );
    senha = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Senha',
      validator: (context, val) =>
          val == null || val.isEmpty ? 'Por favor informe a Senha.' : null,
    );
  }

  void dispose() {
    nomeUsuario.controller.dispose();
    nomeUsuario.focusNode.dispose();
    senha.controller.dispose();
    senha.focusNode.dispose();
  }
}
