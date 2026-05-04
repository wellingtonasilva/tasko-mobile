import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

class UsuarioAdicionarControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData nomeCompleto;
  late final CustomFormFieldData numeroTelefone;
  late final CustomFormFieldData nomeUsuario;
  late final CustomFormFieldData senha;
  late final CustomFormFieldData repetirSenha;

  UsuarioAdicionarControllers() {
    nomeCompleto = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Nome Completo',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o Nome Completo.'
          : null,
    );
    nomeUsuario = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Usuário/E-mail',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o Usuário/E-mail.'
          : null,
    );
    numeroTelefone = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Número Telefone',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o Número Telefone.'
          : null,
    );
    senha = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: '',
      validator: (context, val) =>
          val == null || val.isEmpty ? 'Por favor informe a Senha.' : null,
    );
    repetirSenha = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: '',
      validator: (context, val) =>
          val == null || val.isEmpty ? 'Por favor repita a Senha.' : null,
    );
  }
}
