import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';

class VendedorManterControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData id;
  late final CustomFormFieldData codigoVendedor;
  late final CustomFormFieldData nomeVendedor;
  late final CustomFormFieldData numeroCPF;
  late final CustomFormFieldData email;
  late final CustomFormFieldData numeroTelefone;
  late final CustomFormFieldData valorMetaMensal;
  late final CustomFormFieldData percentualComissao;
  late final CustomFormFieldData ultimoSincronismo;
  late final CustomFormFieldData codigoDispositivo;

  VendedorManterControllers() {
    id = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'ID',
      validator: (context, val) =>
          val == null || val.isEmpty ? 'Por favor informe o ID.' : null,
    );
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
    ultimoSincronismo = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Último Sincronismo',
    );
    codigoDispositivo = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Código Dispositivo',
    );
  }

  void dispose() {
    id.controller.dispose();
    id.focusNode.dispose();
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
    ultimoSincronismo.controller.dispose();
    ultimoSincronismo.focusNode.dispose();
    codigoDispositivo.controller.dispose();
    codigoDispositivo.focusNode.dispose();
  }

  void updateFormFields(VendedorResponse vendedor) {
    id.controller.text = vendedor.id.toString();
    codigoVendedor.controller.text = vendedor.codigoVendedor;
    nomeVendedor.controller.text = vendedor.nomeVendedor;
    numeroCPF.controller.text = vendedor.numeroCPF;
    email.controller.text = vendedor.email;
    numeroTelefone.controller.text = vendedor.numeroTelefone;
    valorMetaMensal.controller.text =
        vendedor.valorMetaMensal?.toStringAsFixed(2) ?? '';
    percentualComissao.controller.text = vendedor.percentualComissao
        .toStringAsFixed(2);
    ultimoSincronismo.controller.text =
        vendedor.ultimoSincronismo?.toIso8601String() ?? '';
    codigoDispositivo.controller.text = vendedor.codigoDispositivo ?? '';
  }
}
