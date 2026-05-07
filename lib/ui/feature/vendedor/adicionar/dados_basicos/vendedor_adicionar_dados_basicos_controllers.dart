import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';

class VendedorAdicionarDadosBasicosControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData codigoVendedor;
  late final CustomFormFieldData nomeVendedor;
  late final CustomFormFieldData numeroCPF;

  VendedorAdicionarDadosBasicosControllers() {
    final cpfMask = MaskTextInputFormatter(
      mask: '###.###.###-##',
      filter: {'#': RegExp('[0-9]')},
    );
    codigoVendedor = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.sell,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Código Vendedor',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o Código Vendedor.'
          : null,
    );
    nomeVendedor = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.person,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Nome Vendedor',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o Nome Vendedor.'
          : null,
    );
    numeroCPF = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.perm_identity,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Número CPF',
      validator: (context, val) =>
          val == null || val.isEmpty ? 'Por favor informe o Número CPF.' : null,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, cpfMask],
      keyboardType: TextInputType.number,
    );
  }

  void dispose() {
    codigoVendedor.controller.dispose();
    codigoVendedor.focusNode.dispose();
    nomeVendedor.controller.dispose();
    nomeVendedor.focusNode.dispose();
    numeroCPF.controller.dispose();
    numeroCPF.focusNode.dispose();
  }

  void updateFormFields(VendedorResponse? vendedor) {
    codigoVendedor.controller.text = vendedor?.codigoVendedor ?? '';
    nomeVendedor.controller.text = vendedor?.nomeVendedor ?? '';
    numeroCPF.controller.text = vendedor?.numeroCPF ?? '';
  }
}
