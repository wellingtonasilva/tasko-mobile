import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

class CriarContaControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData nomeEmpresa;
  late final CustomFormFieldData email;
  late final CustomFormFieldData senha;
  late final CustomFormFieldData repetirSenha;

  CriarContaControllers() {
    nomeEmpresa = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Nome da Empresa',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o Nome da Empresa.'
          : null,
    );
    email = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Email',
      validator: (context, val) =>
          val == null || val.isEmpty ? 'Por favor informe o Email.' : null,
    );
    senha = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Senha',
      validator: (context, val) =>
          val == null || val.isEmpty ? 'Por favor informe a Senha.' : null,
    );
    repetirSenha = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Repetir Senha',
      validator: (context, val) =>
          val == null || val.isEmpty ? 'Por favor repita a Senha.' : null,
    );
  }

  void dispose() {
    nomeEmpresa.controller.dispose();
    nomeEmpresa.focusNode.dispose();
    email.controller.dispose();
    email.focusNode.dispose();
    senha.controller.dispose();
    senha.focusNode.dispose();
    repetirSenha.controller.dispose();
    repetirSenha.focusNode.dispose();
  }
}
