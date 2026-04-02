import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

class ClienteAdicionarControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData codigoCliente;
  late final CustomFormFieldData razaoSocial;
  late final CustomFormFieldData nomeFantasia;
  late final CustomFormFieldData cnpjCpf;
  late final CustomFormFieldData cidade;
  late final CustomFormFieldData estado;
  late final CustomFormFieldData limiteCredito;

  ClienteAdicionarControllers() {
    codigoCliente = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Codigo Cliente',
    );
    razaoSocial = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Razao Social',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe a Razao Social.'
          : null,
    );
    nomeFantasia = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Nome Fantasia',
    );
    cnpjCpf = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'CNPJ/CPF',
    );
    cidade = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Cidade',
    );
    estado = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Estado',
    );
    limiteCredito = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Limite de Credito',
    );
  }

  void dispose() {
    codigoCliente.controller.dispose();
    codigoCliente.focusNode.dispose();
    razaoSocial.controller.dispose();
    razaoSocial.focusNode.dispose();
    nomeFantasia.controller.dispose();
    nomeFantasia.focusNode.dispose();
    cnpjCpf.controller.dispose();
    cnpjCpf.focusNode.dispose();
    cidade.controller.dispose();
    cidade.focusNode.dispose();
    estado.controller.dispose();
    estado.focusNode.dispose();
    limiteCredito.controller.dispose();
    limiteCredito.focusNode.dispose();
  }
}
