import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';
import 'package:tasko_mobile/common/widgets/textfield/decimal_text_input_formatter.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';

class ProdutoAdicionarPecosMargensControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData precoCusto;
  late final CustomFormFieldData precoSugerido;
  late final CustomFormFieldData margemMinima;
  late final CustomFormFieldData aliquotaIcms;
  late final CustomFormFieldData aliquotaIpi;
  late final CustomFormFieldData quantidadeDisponivel;
  late final CustomFormFieldData quantidadeReservada;
  late final CustomFormFieldData pesoLiquido;
  late final CustomFormFieldData dimensaoAltura;
  late final CustomFormFieldData dimensaoLargura;
  late final CustomFormFieldData dimensaoProfundidade;

  ProdutoAdicionarPecosMargensControllers() {
    precoCusto = CustomFormFieldData(
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
      labelText: 'Preço de Custo',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o Preço de Custo.'
          : null,
    );

    precoSugerido = CustomFormFieldData(
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
      labelText: 'Preço Sugerido',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o Preço Sugerido.'
          : null,
    );

    margemMinima = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.percent,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(decimalDigits: 2),
      ],
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Margem Mínima (%)',
    );
    aliquotaIcms = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.percent,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(decimalDigits: 2),
      ],
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Alíquota ICMS (%)',
    );

    aliquotaIpi = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.percent,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(decimalDigits: 2),
      ],
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Alíquota IPI (%)',
    );
    quantidadeDisponivel = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.inventory_2,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(decimalDigits: 2),
      ],
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Quantidade Disponível',
    );
    quantidadeReservada = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.bookmark,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(decimalDigits: 2),
      ],
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Quantidade Reservada',
    );
    pesoLiquido = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.scale,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(decimalDigits: 2),
      ],
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Peso Líquido',
    );
    dimensaoAltura = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.height,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(decimalDigits: 2),
      ],
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Altura',
    );
    dimensaoLargura = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.straighten,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(decimalDigits: 2),
      ],
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Largura',
    );
    dimensaoProfundidade = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.view_in_ar,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        DecimalTextInputFormatter(decimalDigits: 2),
      ],
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Profundidade',
    );
  }

  void dispose() {
    precoCusto.controller.dispose();
    precoCusto.focusNode.dispose();
    precoSugerido.controller.dispose();
    precoSugerido.focusNode.dispose();
    margemMinima.controller.dispose();
    margemMinima.focusNode.dispose();
    aliquotaIcms.controller.dispose();
    aliquotaIcms.focusNode.dispose();
    aliquotaIpi.controller.dispose();
    aliquotaIpi.focusNode.dispose();
    quantidadeDisponivel.controller.dispose();
    quantidadeDisponivel.focusNode.dispose();
    quantidadeReservada.controller.dispose();
    quantidadeReservada.focusNode.dispose();
    pesoLiquido.controller.dispose();
    pesoLiquido.focusNode.dispose();
    dimensaoAltura.controller.dispose();
    dimensaoAltura.focusNode.dispose();
    dimensaoLargura.controller.dispose();
    dimensaoLargura.focusNode.dispose();
    dimensaoProfundidade.controller.dispose();
    dimensaoProfundidade.focusNode.dispose();
  }

  void updateFormFields(ProdutoResponse? draft) {
    precoCusto.controller.text = draft?.precoCusto?.toStringAsFixed(2) ?? '';
    precoSugerido.controller.text =
        draft?.precoSugerido?.toStringAsFixed(2) ?? '';
    margemMinima.controller.text =
        draft?.margemMinima?.toStringAsFixed(2) ?? '';
    aliquotaIcms.controller.text =
        draft?.aliquotaIcms?.toStringAsFixed(2) ?? '';
    aliquotaIpi.controller.text = draft?.aliquotaIpi?.toStringAsFixed(2) ?? '';
    quantidadeDisponivel.controller.text =
        draft?.quantidadeDisponivel?.toString() ?? '';
    quantidadeReservada.controller.text =
        draft?.quantidadeReservada?.toString() ?? '';
    pesoLiquido.controller.text = draft?.pesoLiquido?.toStringAsFixed(2) ?? '';
    dimensaoAltura.controller.text =
        draft?.dimensaoAltura?.toStringAsFixed(2) ?? '';
    dimensaoLargura.controller.text =
        draft?.dimensaoLargura?.toStringAsFixed(2) ?? '';
    dimensaoProfundidade.controller.text =
        draft?.dimensaoProfundidade?.toStringAsFixed(2) ?? '';
  }
}
