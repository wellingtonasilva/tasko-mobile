import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';

class ProdutoAdicionarDadosBasicosControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData nomeProduto;
  late final CustomFormFieldData descricaoProduto;
  late final CustomFormFieldData grupoId;
  late final CustomFormFieldData subgrupoId;
  late final CustomFormFieldData unidadeMedidaId;
  late final CustomFormFieldData marca;
  late final CustomFormFieldData fornecedor;

  ProdutoAdicionarDadosBasicosControllers() {
    nomeProduto = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.shopping_bag,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Nome Produto',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o Nome do Produto.'
          : null,
    );
    descricaoProduto = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.description,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Descrição Produto',
    );
    grupoId = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.category,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Grupo',
    );
    subgrupoId = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.subdirectory_arrow_right,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Subgrupo',
    );
    unidadeMedidaId = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.straighten,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Unidade de Medida',
    );
    marca = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.branding_watermark,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Marca',
    );
    fornecedor = CustomFormFieldData(
      prefixIcon: const Icon(
        Icons.local_shipping,
        color: kColorStyleSecondinaryLight300,
        size: 20,
      ),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Fornecedor',
    );
  }

  void dispose() {
    nomeProduto.controller.dispose();
    nomeProduto.focusNode.dispose();
    descricaoProduto.controller.dispose();
    descricaoProduto.focusNode.dispose();
    grupoId.controller.dispose();
    grupoId.focusNode.dispose();
    subgrupoId.controller.dispose();
    subgrupoId.focusNode.dispose();
    unidadeMedidaId.controller.dispose();
    unidadeMedidaId.focusNode.dispose();
    marca.controller.dispose();
    marca.focusNode.dispose();
    fornecedor.controller.dispose();
    fornecedor.focusNode.dispose();
  }

  void updateFormFields(ProdutoResponse? draft) {
    nomeProduto.controller.text = draft?.nomeProduto ?? '';
    descricaoProduto.controller.text = draft?.descricaoProduto ?? '';
    grupoId.controller.text = draft?.grupoNome ?? '';
    subgrupoId.controller.text = draft?.subgrupoNome ?? '';
    unidadeMedidaId.controller.text = draft?.unidadeMedidaNome ?? '';
    marca.controller.text = draft?.marca ?? '';
    fornecedor.controller.text = draft?.fornecedor ?? '';
  }
}
