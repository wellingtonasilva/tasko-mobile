import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';

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
}
