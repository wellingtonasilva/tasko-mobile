import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';

class ProdutoManterControllers {
  final formKey = GlobalKey<FormState>();
  late final CustomFormFieldData id;
  late final CustomFormFieldData codigoProduto;
  late final CustomFormFieldData nomeProduto;
  late final CustomFormFieldData descricaoProduto;
  late final CustomFormFieldData precoProduto;
  late final CustomFormFieldData quantidadeEstoque;
  late final CustomFormFieldData marcaProduto;
  late final CustomFormFieldData fornecedorProduto;

  ProdutoManterControllers() {
    id = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'ID',
      validator: (context, val) =>
          val == null || val.isEmpty ? 'Por favor informe o ID.' : null,
    );
    codigoProduto = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Código Produto',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o Código Produto.'
          : null,
    );
    nomeProduto = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Nome Produto',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o Nome Produto.'
          : null,
    );
    descricaoProduto = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Descrição Produto',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe a Descrição do Produto.'
          : null,
    );
    precoProduto = CustomFormFieldData(
      prefixIcon: Icon(Icons.monetization_on),
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Preço Produto',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o Preço do Produto.'
          : null,
    );
    quantidadeEstoque = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Quantidade Estoque',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe a Quantidade em Estoque.'
          : null,
    );
    marcaProduto = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Marca Produto',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe a Marca do Produto.'
          : null,
    );
    fornecedorProduto = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Fornecedor Produto',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o Fornecedor do Produto.'
          : null,
    );
  }

  void updateFormFields(ProdutoResponse produto) {
    codigoProduto.controller.text = produto.id.toString();
    nomeProduto.controller.text = produto.nomeProduto ?? '';
    descricaoProduto.controller.text = produto.descricaoProduto ?? '';
    precoProduto.controller.text =
        produto.precoSugerido?.toStringAsFixed(2) ?? '';
    quantidadeEstoque.controller.text =
        produto.quantidadeDisponivel?.toString() ?? '';
    marcaProduto.controller.text = produto.marca ?? '';
    fornecedorProduto.controller.text = produto.fornecedor ?? '';
  }

  void dispose() {
    id.controller.dispose();
    codigoProduto.controller.dispose();
    nomeProduto.controller.dispose();
    descricaoProduto.controller.dispose();
    precoProduto.controller.dispose();
    quantidadeEstoque.controller.dispose();
    marcaProduto.controller.dispose();
    fornecedorProduto.controller.dispose();

    id.focusNode.dispose();
    codigoProduto.focusNode.dispose();
    nomeProduto.focusNode.dispose();
    descricaoProduto.focusNode.dispose();
    precoProduto.focusNode.dispose();
    quantidadeEstoque.focusNode.dispose();
    marcaProduto.focusNode.dispose();
    fornecedorProduto.focusNode.dispose();
  }
}
