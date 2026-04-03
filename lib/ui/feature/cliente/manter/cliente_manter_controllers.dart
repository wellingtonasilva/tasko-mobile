import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';

class ClienteManterControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData codigoCliente;
  late final CustomFormFieldData razaoSocial;
  late final CustomFormFieldData nomeFantasia;
  late final CustomFormFieldData cnpjCpf;
  late final CustomFormFieldData cidade;
  late final CustomFormFieldData estado;
  late final CustomFormFieldData limiteCredito;

  ClienteManterControllers() {
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

  void updateFormFields(ClienteResponse cliente) {
    codigoCliente.controller.text = cliente.codigoCliente ?? '';
    razaoSocial.controller.text = cliente.razaoSocial;
    nomeFantasia.controller.text = cliente.nomeFantasia ?? '';
    cnpjCpf.controller.text = cliente.cnpjCpf ?? '';
    cidade.controller.text = cliente.cidade ?? '';
    estado.controller.text = cliente.estado ?? '';
    limiteCredito.controller.text =
        cliente.limiteCredito?.toStringAsFixed(2) ?? '';
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
