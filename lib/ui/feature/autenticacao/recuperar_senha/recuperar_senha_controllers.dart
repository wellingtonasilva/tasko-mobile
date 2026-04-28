import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

class RecuperarSenhaControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData email;

  RecuperarSenhaControllers() {
    email = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'E-mail',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o e-mail associado à sua conta.'
          : null,
    );
  }

  void dispose() {
    email.controller.dispose();
    email.focusNode.dispose();
  }
}
