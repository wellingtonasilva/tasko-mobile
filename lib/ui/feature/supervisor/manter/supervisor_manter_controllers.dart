import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';

class SupervisorManterControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData nomeSupervisor;

  SupervisorManterControllers() {
    nomeSupervisor = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.person,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Nome do Supervisor',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o Nome do Supervisor.'
          : null,
    );
  }

  void dispose() {
    nomeSupervisor.controller.dispose();
    nomeSupervisor.focusNode.dispose();
  }

  void updateFormFields(VendedorSupervisorResponse supervisorAtual) {
    nomeSupervisor.controller.text = supervisorAtual.nomeSupervisor ?? '';
  }
}
