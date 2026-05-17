import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

class SubgrupoAdicionarControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData descricaoSubgrupo;

  SubgrupoAdicionarControllers() {
    descricaoSubgrupo = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Descrição do Subgrupo',
      validator: (context, value) {
        if (value == null || value.isEmpty) {
          return 'A descrição do subgrupo é obrigatória.';
        }
        return null;
      },
    );
  }

  void dispose() {
    descricaoSubgrupo.controller.dispose();
    descricaoSubgrupo.focusNode.dispose();
  }
}
