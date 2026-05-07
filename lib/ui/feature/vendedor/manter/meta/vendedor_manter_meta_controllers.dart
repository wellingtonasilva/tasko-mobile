import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/widgets/textfield/br_phone_input_formatter.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';
import 'package:tasko_mobile/common/widgets/textfield/decimal_text_input_formatter.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';

class VendedorManterMetaControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData email;
  late final CustomFormFieldData numeroTelefone;
  late final CustomFormFieldData numeroTelefoneAlternativo;
  late final CustomFormFieldData valorMetaMensal;
  late final CustomFormFieldData percentualComissao;
  late final CustomFormFieldData ultimoSincronismo;
  late final CustomFormFieldData codigoDispositivo;

  VendedorManterMetaControllers() {
    email = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.mail_outline,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Email',
      validator: (context, val) =>
          val == null || val.isEmpty ? 'Por favor informe o Email.' : null,
    );
    numeroTelefone = CustomFormFieldData(
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        BrPhoneInputFormatter(),
      ],
      prefixIcon: const Icon(
        Icons.phone,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Telefone',
      validator: (context, val) =>
          val == null || val.isEmpty ? 'Por favor informe o Telefone.' : null,
    );
    numeroTelefoneAlternativo = CustomFormFieldData(
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        BrPhoneInputFormatter(),
      ],
      prefixIcon: const Icon(
        Icons.phone,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Telefone Alternativo',
    );
    valorMetaMensal = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.attach_money,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Valor da Meta Mensal (R\$)',
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(decimalDigits: 2),
      ],
    );
    percentualComissao = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.percent,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Percentual Comissão (%)',
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(decimalDigits: 2),
      ],
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
    email.controller.dispose();
    numeroTelefone.controller.dispose();
    numeroTelefoneAlternativo.controller.dispose();
    valorMetaMensal.controller.dispose();
    percentualComissao.controller.dispose();
    ultimoSincronismo.controller.dispose();
    codigoDispositivo.controller.dispose();
  }

  void updateFormFields(VendedorResponse? vendedor) {
    email.controller.text = vendedor?.email ?? '';
    numeroTelefone.controller.text = vendedor?.numeroTelefone ?? '';
    //numeroTelefoneAlternativo.controller.text =
    //    vendedor?.numeroTelefoneAlternativo ?? '';
    valorMetaMensal.controller.text =
        vendedor?.valorMetaMensal?.toStringAsFixed(2) ?? '';
    percentualComissao.controller.text =
        vendedor?.percentualComissao?.toStringAsFixed(2) ?? '';
    //ultimoSincronismo.controller.text = vendedor?.ultimoSincronismo != null
    //    ? DateFormat('dd/MM/yyyy HH:mm:ss').format(vendedor!.ultimoSincronismo!)
    //    : '';
    codigoDispositivo.controller.text = vendedor?.codigoDispositivo ?? '';
  }
}
