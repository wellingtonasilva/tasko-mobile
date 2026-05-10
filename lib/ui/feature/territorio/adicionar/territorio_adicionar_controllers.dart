import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

class TerritorioAdicionarControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData nomeTerritorio;
  late final CustomFormFieldData descricaoTerritorio;
  late final CustomFormFieldData nomeRegiao;
  late final CustomFormFieldData estado;

  TerritorioAdicionarControllers() {
    nomeTerritorio = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Nome do Território',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o Nome do Território.'
          : null,
    );
    descricaoTerritorio = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Descrição do Território',
    );
    nomeRegiao = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Nome da Região',
    );
    estado = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Estado',
    );
  }

  void dispose() {
    nomeTerritorio.controller.dispose();
    nomeTerritorio.focusNode.dispose();
    descricaoTerritorio.controller.dispose();
    descricaoTerritorio.focusNode.dispose();
    nomeRegiao.controller.dispose();
    nomeRegiao.focusNode.dispose();
    estado.controller.dispose();
    estado.focusNode.dispose();
  }
}
