import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';
import 'package:tasko_mobile/domain/grupo/response/produto_grupo_response.dart';

class GrupoManterControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData descricaoGrupo;

  GrupoManterControllers() {
    descricaoGrupo = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Descrição do Grupo',
      validator: (context, value) {
        if (value == null || value.isEmpty) {
          return 'A descrição do grupo é obrigatória.';
        }
        return null;
      },
    );
  }

  void dispose() {
    descricaoGrupo.controller.dispose();
    descricaoGrupo.focusNode.dispose();
  }

  void updateFormFields(ProdutoGrupoResponse grupoAtual) {
    descricaoGrupo.controller.text = grupoAtual.descricaoGrupo ?? '';
  }
}
