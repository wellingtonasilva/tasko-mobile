import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/domain/dropdown_loading_state.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/custom_dropdown_button_form_field.dart';
import 'package:tasko_mobile/domain/condicao_pagamento/request/adicionar_condicao_pagamento_request.dart';
import 'package:tasko_mobile/domain/forma_pagamento/response/forma_pagamento_response.dart';
import 'package:tasko_mobile/ui/feature/condicao_pagamento/adicionar/condicao_pagamento_adicionar_controllers.dart';
import 'package:tasko_mobile/ui/feature/condicao_pagamento/adicionar/condicao_pagamento_adicionar_ui_state.dart';
import 'package:tasko_mobile/ui/feature/condicao_pagamento/adicionar/condicao_pagamento_adicionar_view_model.dart';
import 'package:tasko_mobile/util/result.dart';

class CondicaoPagamentoAdicionarScreen extends BaseScreen {
  const CondicaoPagamentoAdicionarScreen({super.key});

  @override
  BaseScreenState<CondicaoPagamentoAdicionarScreen> createState() =>
      _CondicaoPagamentoAdicionarScreenState();
}

class _CondicaoPagamentoAdicionarScreenState
    extends BaseScreenState<CondicaoPagamentoAdicionarScreen> {
  late final CondicaoPagamentoAdicionarControllers _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = CondicaoPagamentoAdicionarControllers();

    final viewModel = ref.read(
      condicaoPagamentoAdicionarViewModelProvider.notifier,
    );
    viewModel.showSnackBar = (String message, Result result) {
      if (mounted) {
        if (result is Success) {
          showSnackBar(message);
        } else if (result is Failure) {
          showSnackBar(message, isError: true);
        }
      }
    };

    viewModel.onAdicionarSucesso = () {
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    };

    viewModel.onStartEvent = () {
      if (mounted) {
        showLoading();
      }
    };
    viewModel.onFinishEvent = () {
      if (mounted) {
        hideLoading();
      }
    };
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: kColorStylePrimary100,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 15.0,
                left: 15.0,
                right: 15.0,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: kColorStylePrimary0,
                ),
                child: Form(
                  key: _controllers.formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTituloBarDefault(
                          title: 'Adicionar Condição de Pagamento',
                          onClosePressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              buildTextField(
                                _controllers.descricaoCondicaoPagamento,
                                isMandatory: true,
                              ),
                              SizedBox(height: 10),
                              buildTextField(
                                _controllers.condicaoPagamento,
                                isMandatory: false,
                              ),
                              const SizedBox(height: 15),
                              const Text('Forma de Pagamento'),
                              const SizedBox(height: 10),
                              _buildLoadingDropdownFieldFormaPagamento(
                                ref.watch(
                                  condicaoPagamentoAdicionarViewModelProvider,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(color: kColorStyleSecondinaryLight200),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: CustomButtonSecondary(
                              label: 'Cancelar',
                              onPressed: () {
                                _handleCancelarPressed();
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: CustomButtonPrimary(
                              label: 'Salvar',
                              onPressed: () {
                                _handleSalvarPressed();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleCancelarPressed() {
    Navigator.of(context).pop(false);
  }

  void _handleSalvarPressed() {
    if (!(_controllers.formKey.currentState?.validate() ?? false)) return;

    final request = AdicionarCondicaoPagamentoRequest(
      descricaoCondicaoPagamento: _controllers
          .descricaoCondicaoPagamento
          .controller
          .text
          .trim(),
      condicaoPagamento: _controllers.condicaoPagamento.controller.text.trim(),
      formaPagamentoId: ref
          .read(condicaoPagamentoAdicionarViewModelProvider)
          .selectedFormaPagamento
          ?.id,
    );

    ref
        .read(condicaoPagamentoAdicionarViewModelProvider)
        .adicionarCondicaoPagamentoCommand
        .execute(request);
  }

  Widget _buildLoadingDropdownFieldFormaPagamento(
    CondicaoPagamentoAdicionarUiState viewModel,
  ) {
    final notifier = ref.read(
      condicaoPagamentoAdicionarViewModelProvider.notifier,
    );
    return switch (notifier.formaPagamentoDropdownState) {
      DropdownLoadingState.loading => buildLoadingIndicator(),
      DropdownLoadingState.ready => buildDropdownFieldFormaPagamento(viewModel),
      DropdownLoadingState.error => buildDropdownFieldFormaPagamento(viewModel),
    };
  }

  Widget buildDropdownFieldFormaPagamento(
    CondicaoPagamentoAdicionarUiState viewModel,
  ) {
    final notifier = ref.read(
      condicaoPagamentoAdicionarViewModelProvider.notifier,
    );
    final selectedFormaPagamento =
        viewModel.selectedFormaPagamento ??
        notifier.computedSelectedFormaPagamento;

    return CustomDropdownButtonFormField<FormaPagamentoResponse>(
      prefixIcon: Padding(
        padding: const EdgeInsetsDirectional.only(start: 12, end: 8),
        child: Icon(
          Icons.payments,
          color: kColorStyleSecondinaryLight300,
          size: 20,
        ),
      ),
      hint: 'Selecione uma Forma de Pagamento',
      items: viewModel.formasPagamento ?? [],
      itemLabelBuilder: (item) => item.descricaoFormaPagamento ?? '',
      selectedValue: selectedFormaPagamento,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecione uma Forma de Pagamento.';
        }
        return null;
      },
      onChanged: (value) {
        notifier.selecionarFormaPagamento(value);
      },
    );
  }
}
