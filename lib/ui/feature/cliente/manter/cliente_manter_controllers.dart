import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';

class ClienteManterControllers {
  final formKey = GlobalKey<FormState>();
  late final PageController pageController;

  late final CustomFormFieldData cidade;
  late final CustomFormFieldData estado;

  ClienteManterControllers() {
    pageController = PageController();

    cidade = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.location_pin,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Cidade',
    );
    estado = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.map,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Estado',
    );
  }

  void updateFormFields(ClienteResponse cliente) {
    cidade.controller.text = cliente.cidade ?? '';
    estado.controller.text = cliente.estado ?? '';
  }

  void dispose() {
    cidade.controller.dispose();
    cidade.focusNode.dispose();
    estado.controller.dispose();
    estado.focusNode.dispose();
    pageController.dispose();
  }
}
