import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/widgets/textfield/br_phone_input_formatter.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';

class ClienteManterContatoEnderecoControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData numeroTelefonePrincipal;
  late final CustomFormFieldData numeroTelefoneSecundario;
  late final CustomFormFieldData emailPrincipal;
  late final CustomFormFieldData cep;
  late final CustomFormFieldData logradouro;
  late final CustomFormFieldData logradouroNumero;
  late final CustomFormFieldData complemento;
  late final CustomFormFieldData bairro;
  late final CustomFormFieldData cidade;
  late final CustomFormFieldData estado;
  late final CustomFormFieldData observacao;

  ClienteManterContatoEnderecoControllers() {
    numeroTelefonePrincipal = CustomFormFieldData(
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
      labelText: 'Telefone Principal',
    );
    numeroTelefoneSecundario = CustomFormFieldData(
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
      labelText: 'Telefone Secundário',
    );
    emailPrincipal = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.mail_outline,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'E-mail',
    );
    cep = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.location_on,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'CEP',
    );
    logradouro = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.business_outlined,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Endereço',
    );
    logradouroNumero = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.tag_outlined,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Número',
    );
    complemento = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.notes_outlined,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Complemento',
    );
    bairro = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.person_outline,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Bairro',
    );
    cidade = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.location_city_outlined,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Cidade',
    );
    estado = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.map_outlined,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Estado',
    );
    observacao = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.notes_outlined,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Observação',
    );
  }

  void dispose() {
    numeroTelefonePrincipal.controller.dispose();
    numeroTelefoneSecundario.controller.dispose();
    emailPrincipal.controller.dispose();
    cep.controller.dispose();
    logradouro.controller.dispose();
    logradouroNumero.controller.dispose();
    complemento.controller.dispose();
    bairro.controller.dispose();
    cidade.controller.dispose();
    estado.controller.dispose();
    observacao.controller.dispose();
  }

  void updateFormFields(ClienteResponse? draft) {
    numeroTelefonePrincipal.controller.text = draft?.numeroTelefone ?? '';
    numeroTelefoneSecundario.controller.text =
        draft?.numeroTelefoneSecundario ?? '';
    emailPrincipal.controller.text = draft?.email ?? '';
    cep.controller.text = draft?.cep ?? '';
    logradouro.controller.text = draft?.logradouro ?? '';
    logradouroNumero.controller.text = draft?.logradouroNumero ?? '';
    complemento.controller.text = draft?.complemento ?? '';
    bairro.controller.text = draft?.bairro ?? '';
    cidade.controller.text = draft?.cidade ?? '';
    estado.controller.text = draft?.estado ?? '';
    observacao.controller.text = draft?.observacao ?? '';
  }
}
