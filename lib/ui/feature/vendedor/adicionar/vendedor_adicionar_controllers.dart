import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

class VendedorAdicionarControllers {
  final formKey = GlobalKey<FormState>();
  late final PageController pageController;
  late final CustomFormFieldData codigoVendedor;
  late final CustomFormFieldData nomeVendedor;
  late final CustomFormFieldData numeroCPF;
  late final CustomFormFieldData email;
  late final CustomFormFieldData numeroTelefone;
  late final CustomFormFieldData valorMetaMensal;
  late final CustomFormFieldData percentualComissao;

  VendedorAdicionarControllers() {
    pageController = PageController();
    codigoVendedor = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Código Vendedor',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o Código Vendedor.'
          : null,
    );
    nomeVendedor = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Nome Vendedor',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o Nome Vendedor.'
          : null,
    );
    numeroCPF = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Número CPF',
      validator: (context, val) =>
          val == null || val.isEmpty ? 'Por favor informe o Número CPF.' : null,
    );
    email = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Email',
      validator: (context, val) =>
          val == null || val.isEmpty ? 'Por favor informe o Email.' : null,
    );
    numeroTelefone = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Número Telefone',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o Número Telefone.'
          : null,
    );
    valorMetaMensal = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Valor Meta Mensal',
    );
    percentualComissao = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Percentual Comissão',
    );
  }

  void dispose() {
    codigoVendedor.controller.dispose();
    codigoVendedor.focusNode.dispose();
    nomeVendedor.controller.dispose();
    nomeVendedor.focusNode.dispose();
    numeroCPF.controller.dispose();
    numeroCPF.focusNode.dispose();
    email.controller.dispose();
    email.focusNode.dispose();
    numeroTelefone.controller.dispose();
    numeroTelefone.focusNode.dispose();
    valorMetaMensal.controller.dispose();
    valorMetaMensal.focusNode.dispose();
    percentualComissao.controller.dispose();
    percentualComissao.focusNode.dispose();
    pageController.dispose();
  }
}
