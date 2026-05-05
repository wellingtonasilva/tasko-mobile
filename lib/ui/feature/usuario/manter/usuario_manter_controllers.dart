import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_response.dart';

class UsuarioManterControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData id;
  late final CustomFormFieldData nomeCompleto;
  late final CustomFormFieldData numeroTelefone;
  late final CustomFormFieldData nomeUsuario;

  UsuarioManterControllers() {
    id = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'ID',
      validator: (context, val) =>
          val == null || val.isEmpty ? 'Por favor informe o ID.' : null,
    );
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
  }

  void updateFormFields(UsuarioResponse usuario) {
    id.controller.text = usuario.id.toString();
    nomeUsuario.controller.text = usuario.nomeUsuario;
    nomeCompleto.controller.text = usuario.nomeCompleto ?? '';
    numeroTelefone.controller.text = usuario.numeroTelefone ?? '';
  }

  void dispose() {
    id.controller.dispose();
    id.focusNode.dispose();
    nomeUsuario.controller.dispose();
    nomeUsuario.focusNode.dispose();
    nomeCompleto.controller.dispose();
    nomeCompleto.focusNode.dispose();
    numeroTelefone.controller.dispose();
    numeroTelefone.focusNode.dispose();
  }
}
