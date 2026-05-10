import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_territorio_response.dart';

class TerritorioManterControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData nomeTerritorio;
  late final CustomFormFieldData descricaoTerritorio;
  late final CustomFormFieldData nomeRegiao;
  late final CustomFormFieldData estado;

  TerritorioManterControllers() {
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
    descricaoTerritorio.controller.dispose();
    nomeRegiao.controller.dispose();
    estado.controller.dispose();
  }

  void updateFormFields(VendedorTerritorioResponse territorioAtual) {
    nomeTerritorio.controller.text = territorioAtual.nomeTerritorio ?? '';
    descricaoTerritorio.controller.text =
        territorioAtual.descricaoTerritorio ?? '';
    nomeRegiao.controller.text = territorioAtual.nomeRegiao ?? '';
    estado.controller.text = territorioAtual.estado ?? '';
  }
}
