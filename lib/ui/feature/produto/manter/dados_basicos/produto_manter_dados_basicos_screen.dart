import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/domain/dropdown_loading_state.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/custom_dropdown_button_form_field.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_item.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_line.dart';
import 'package:tasko_mobile/domain/grupo/response/produto_grupo_response.dart';
import 'package:tasko_mobile/domain/subgrupo/response/produto_subgrupo_response.dart';
import 'package:tasko_mobile/domain/unidade_medida/response/produto_unidade_medida_response.dart';
import 'package:tasko_mobile/ui/feature/produto/manter/dados_basicos/produto_manter_dados_basicos_controllers.dart';
import 'package:tasko_mobile/ui/feature/produto/manter/produto_manter_ui_state.dart';
import 'package:tasko_mobile/ui/feature/produto/manter/produto_manter_view_model.dart';
import 'package:tasko_mobile/util/result.dart';

class ProdutoManterDadosBasicosScreen extends BaseScreen {
  final Function(String value) onPrevious;
  final Function(String value) onNext;

  const ProdutoManterDadosBasicosScreen({
    super.key,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  BaseScreenState<ProdutoManterDadosBasicosScreen> createState() =>
      _ProdutoManterDadosBasicosScreenState();
}

class _ProdutoManterDadosBasicosScreenState
    extends BaseScreenState<ProdutoManterDadosBasicosScreen> {
  late final ProdutoManterDadosBasicosControllers _controllers;
  String? _hydratedDraftKey;

  @override
  void initState() {
    super.initState();
    _controllers = ProdutoManterDadosBasicosControllers();

    final viewModel = ref.read(produtoManterViewModelProvider.notifier);
    viewModel.showSnackBar = (String message, Result result) {
      if (mounted) {
        if (result is Success) {
          showSnackBar(message);
        } else if (result is Failure) {
          showSnackBar(message, isError: true);
        }
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
    final viewModel = ref.watch(produtoManterViewModelProvider);
    final draft = viewModel.produtoDraft;
    final draftKey =
        '${draft?.codigoProduto ?? ''}|${draft?.nomeProduto ?? ''}|${draft?.descricaoProduto ?? ''}';

    if (_hydratedDraftKey != draftKey) {
      _controllers.updateFormFields(draft);
      _hydratedDraftKey = draftKey;
    }

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
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTituloBarDefault(
                          title: 'Manter Produto',
                          onClosePressed: () => context.pop(false),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: _controllers.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomStepperItem(
                                        title: "Dados Básicos",
                                        active: true,
                                        textStyle: kTestStyleRegularText12,
                                      ),
                                      Expanded(
                                        child: CustomStepperLine(
                                          width: double.infinity,
                                        ),
                                      ),
                                      CustomStepperItem(
                                        title: "Preços e Margens",
                                        active: false,
                                        textStyle: kTestStyleRegularText12,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Dados Básicos',
                                              style: kTestStyleMediumText16
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                buildTextField(
                                  _controllers.nomeProduto,
                                  isMandatory: true,
                                ),
                                SizedBox(height: 10),
                                buildTextField(_controllers.descricaoProduto),
                                SizedBox(height: 25),
                                const Text('Grupo'),
                                const SizedBox(height: 10),
                                _buildLoadingDropdownFieldGrupo(viewModel),
                                const SizedBox(height: 15),
                                const Text('Subgrupo'),
                                const SizedBox(height: 5),
                                _buildLoadingDropdownFieldSubgrupo(viewModel),
                                SizedBox(height: 10),
                                const Text('Unidade de Medida'),
                                const SizedBox(height: 5),
                                _buildLoadingDropdownFieldUnidadeMedida(
                                  viewModel,
                                ),
                                SizedBox(height: 25),
                                buildTextField(_controllers.marca),
                                SizedBox(height: 10),
                                buildTextField(_controllers.fornecedor),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Divider(color: kColorStyleSecondinaryLight200),
                      const SizedBox(height: 5),
                      //buildSubmitButton(context),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: CustomButtonSecondary(
                              label: 'Cancelar',
                              onPressed: () {
                                context.pop(false);
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: CustomButtonPrimary(
                              label: 'Próximo',
                              onPressed: _onNextPressed,
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

  void _onNextPressed() {
    if (!(_controllers.formKey.currentState?.validate() ?? false)) return;

    final currentState = ref.read(produtoManterViewModelProvider);
    final notifier = ref.read(produtoManterViewModelProvider.notifier);

    notifier.salvarDadosBasicos(
      nomeProduto: _controllers.nomeProduto.controller.text,
      descricaoProduto: _controllers.descricaoProduto.controller.text,
      marca: _controllers.marca.controller.text,
      fornecedor: _controllers.fornecedor.controller.text,
      unidadeMedidaId:
          currentState.selectedUnidadeMedida?.id ??
          notifier.computedSelectedUnidadeMedida?.id,
      grupoId:
          currentState.selectedGrupo?.id ?? notifier.computedSelectedGrupo?.id,
      subgrupoId:
          currentState.selectedSubgrupo?.id ??
          notifier.computedSelectedSubgrupo?.id,
    );

    widget.onNext('Contato e Meta');
  }

  Widget _buildLoadingDropdownFieldGrupo(ProdutoManterUiState viewModel) {
    final notifier = ref.read(produtoManterViewModelProvider.notifier);
    return switch (notifier.grupoDropdownState) {
      DropdownLoadingState.loading => buildLoadingIndicator(),
      DropdownLoadingState.ready => buildDropdownFieldGrupo(viewModel),
      DropdownLoadingState.error => buildDropdownFieldGrupo(viewModel),
    };
  }

  Widget buildDropdownFieldGrupo(ProdutoManterUiState viewModel) {
    final notifier = ref.read(produtoManterViewModelProvider.notifier);
    final selectedGrupo =
        viewModel.selectedGrupo ?? notifier.computedSelectedGrupo;

    return CustomDropdownButtonFormField<ProdutoGrupoResponse>(
      prefixIcon: Padding(
        padding: const EdgeInsetsDirectional.only(start: 12, end: 8),
        child: Icon(
          Icons.category,
          color: kColorStyleSecondinaryLight300,
          size: 20,
        ),
      ),
      hint: 'Selecione um Grupo',
      items: viewModel.grupos ?? [],
      itemLabelBuilder: (item) => item.descricaoGrupo ?? '',
      selectedValue: selectedGrupo,
      onChanged: (value) {
        notifier.selectGrupo(value);
      },
    );
  }

  Widget _buildLoadingDropdownFieldSubgrupo(ProdutoManterUiState viewModel) {
    final notifier = ref.read(produtoManterViewModelProvider.notifier);
    return switch (notifier.subgrupoDropdownState) {
      DropdownLoadingState.loading => buildLoadingIndicator(),
      DropdownLoadingState.ready => _buildDropdownFieldSubgrupo(viewModel),
      DropdownLoadingState.error => _buildDropdownFieldSubgrupo(viewModel),
    };
  }

  Widget _buildDropdownFieldSubgrupo(ProdutoManterUiState viewModel) {
    final notifier = ref.read(produtoManterViewModelProvider.notifier);
    final selectedSubgrupo =
        viewModel.selectedSubgrupo ?? notifier.computedSelectedSubgrupo;

    return CustomDropdownButtonFormField<ProdutoSubgrupoResponse>(
      prefixIcon: Padding(
        padding: const EdgeInsetsDirectional.only(start: 12, end: 8),
        child: Icon(
          Icons.subdirectory_arrow_right,
          color: kColorStyleSecondinaryLight300,
          size: 20,
        ),
      ),
      hint: 'Selecione um Subgrupo',
      items: viewModel.subgrupos ?? [],
      itemLabelBuilder: (item) => item.descricaoSubgrupo ?? '',
      selectedValue: selectedSubgrupo,

      onChanged: (value) {
        notifier.selectSubgrupo(value);
      },
    );
  }

  Widget _buildLoadingDropdownFieldUnidadeMedida(
    ProdutoManterUiState viewModel,
  ) {
    final notifier = ref.read(produtoManterViewModelProvider.notifier);
    return switch (notifier.unidadeMedidaDropdownState) {
      DropdownLoadingState.loading => buildLoadingIndicator(),
      DropdownLoadingState.ready => _buildDropdownFieldUnidadeMedida(viewModel),
      DropdownLoadingState.error => _buildDropdownFieldUnidadeMedida(viewModel),
    };
  }

  Widget _buildDropdownFieldUnidadeMedida(ProdutoManterUiState viewModel) {
    final notifier = ref.read(produtoManterViewModelProvider.notifier);
    final selectedUnidadeMedida =
        viewModel.selectedUnidadeMedida ??
        notifier.computedSelectedUnidadeMedida;

    return CustomDropdownButtonFormField<ProdutoUnidadeMedidaResponse>(
      prefixIcon: Padding(
        padding: const EdgeInsetsDirectional.only(start: 12, end: 8),
        child: Icon(
          Icons.straighten,
          color: kColorStyleSecondinaryLight300,
          size: 20,
        ),
      ),
      hint: 'Selecione uma Unidade de Medida',
      items: viewModel.unidadesMedida ?? [],
      itemLabelBuilder: (item) => item.descricaoUnidadeMedida ?? '',
      selectedValue: selectedUnidadeMedida,
      onChanged: (value) {
        notifier.selectUnidadeMedida(value);
      },
    );
  }
}
