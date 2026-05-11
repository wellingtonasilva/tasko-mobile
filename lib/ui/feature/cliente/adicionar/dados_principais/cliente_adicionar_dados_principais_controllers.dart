import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/widgets/textfield/cpf_cnpj_text_input_formatter.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';
import 'package:tasko_mobile/common/widgets/textfield/decimal_text_input_formatter.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';

class ClienteAdicionarDadosPrincipaisControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData codigoCliente;
  late final CustomFormFieldData razaoSocial;
  late final CustomFormFieldData nomeFantasia;
  late final CustomFormFieldData cnpjCpf;
  late final CustomFormFieldData limiteCredito;

  ClienteAdicionarDadosPrincipaisControllers() {
    final cnpjCpfFormatter = CpfCnpjTextInputFormatter();
    codigoCliente = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.vertical_shades_closed,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Codigo Cliente',
    );
    razaoSocial = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.person_outline,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Razao Social',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe a Razao Social.'
          : null,
    );
    nomeFantasia = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.local_offer,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Nome Fantasia',
    );
    cnpjCpf = CustomFormFieldData(
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        cnpjCpfFormatter,
      ],
      keyboardType: TextInputType.number,
      prefixIcon: const Icon(
        Icons.assignment_ind,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'CNPJ/CPF',
    );

    limiteCredito = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.attach_money,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(decimalDigits: 2),
      ],
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
    limiteCredito.controller.dispose();
    limiteCredito.focusNode.dispose();
  }

  void updateFormFields(ClienteResponse? draft) {
    codigoCliente.controller.text = draft?.codigoCliente ?? '';
    razaoSocial.controller.text = draft?.razaoSocial ?? '';
    nomeFantasia.controller.text = draft?.nomeFantasia ?? '';
    cnpjCpf.controller.text = draft?.cnpjCpf ?? '';
    limiteCredito.controller.text = draft != null
        ? draft.limiteCredito?.toStringAsFixed(2) ?? ''
        : '';
  }
}
