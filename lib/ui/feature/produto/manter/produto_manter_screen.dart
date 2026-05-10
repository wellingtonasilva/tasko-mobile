import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/ui/feature/produto/manter/dados_basicos/produto_manter_dados_basicos_screen.dart';
import 'package:tasko_mobile/ui/feature/produto/manter/precos_margem/produto_manter_precos_margem_screen.dart';
import 'package:tasko_mobile/ui/feature/produto/manter/produto_manter_controllers.dart';

class ProdutoManterScreen extends BaseScreen {
  const ProdutoManterScreen({super.key, required this.produtoId});

  final int produtoId;

  @override
  BaseScreenState<ProdutoManterScreen> createState() =>
      _ProdutoManterScreenState();
}

class _ProdutoManterScreenState extends BaseScreenState<ProdutoManterScreen> {
  late final ProdutoManterControllers _controllers;
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    _controllers = ProdutoManterControllers();
  }

  @override
  Widget buildContent(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: PageView(
        controller: _controllers.pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          ProdutoManterDadosBasicosScreen(
            onPrevious: (value) {
              prevStep();
            },
            onNext: (value) {
              nextStep();
            },
          ),
          ProdutoManterPrecosMargemScreen(
            onPrevious: (value) {
              prevStep();
            },
            onNext: (value) {
              nextStep();
            },
          ),
        ],
      ),
    );
  }

  void nextStep() {
    if (currentStep < 2) {
      setState(() => currentStep++);
      _controllers.pageController.nextPage(
        duration: Duration(milliseconds: 5),
        curve: Curves.ease,
      );
    }
  }

  void prevStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
      _controllers.pageController.previousPage(
        duration: Duration(milliseconds: 5),
        curve: Curves.ease,
      );
    }
  }
}

/*
  @override
  void initState() {
    super.initState();
    _produtoId = widget.produtoId;
    _controllers = ProdutoManterControllers();

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

    ref.read(produtoManterViewModelProvider).listarGrupoCommand.execute();
    ref.read(produtoManterViewModelProvider).listarSubgrupoCommand.execute();

    ref
        .read(produtoManterViewModelProvider)
        .obterPorIdCommand
        .execute((_produtoId));
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(produtoManterViewModelProvider);

    ref.listen<ProdutoManterUiState>(produtoManterViewModelProvider, (
      previous,
      next,
    ) {
      if (next.produto != null) {
        _controllers.updateFormFields(next.produto!);
      }
    });

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
                          title: 'Manter Produtos',
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
                              buildTextField(_controllers.codigoProduto),
                              buildTextField(_controllers.nomeProduto),
                              buildTextField(_controllers.descricaoProduto),
                              buildTextField(_controllers.marcaProduto),
                              buildTextField(_controllers.fornecedorProduto),
                              _buildDropdownGrupo(viewModel),
                              _buildDropdownSubgrupo(viewModel),
                              buildTextField(_controllers.precoProduto),
                              buildTextField(_controllers.quantidadeEstoque),

                              const SizedBox(height: 20),
                            ],
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

  Widget _buildDropdownGrupo(ProdutoManterUiState viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text('Grupo'),
        const SizedBox(height: 10),
        viewModel.listarGrupoCommand.running
            ? buildLoadingIndicator()
            : viewModel.obterPorIdCommand.completed &&
                  viewModel.listarGrupoCommand.completed
            ? _buildDropdownFieldGrupo(viewModel)
            : buildLoadingIndicator(),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDropdownFieldGrupo(ProdutoManterUiState viewModel) {
    viewModel.selectedGrupo = viewModel.grupos?.firstWhere(
      (element) => element.id == viewModel.produto?.grupoId?.toInt(),
      orElse: () => ProdutoGrupoResponse(id: -1, descricaoGrupo: 'Default'),
    );

    if (viewModel.selectedGrupo?.id == -1) {
      viewModel.selectedGrupo = null;
    }

    return CustomDropdownButtonFormField<ProdutoGrupoResponse>(
      hint: 'Selecione um Grupo',
      items: viewModel.grupos ?? [],
      itemLabelBuilder: (item) => item.descricaoGrupo,
      selectedValue: viewModel.selectedGrupo,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecione um Grupo.';
        }
        return null;
      },
      onChanged: (value) {
        viewModel.selectedGrupo = value;
      },
      onSaved: (value) {
        viewModel.selectedGrupo = value;
      },
    );
  }

  Widget _buildDropdownSubgrupo(ProdutoManterUiState viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text('Subgrupo'),
        const SizedBox(height: 10),
        viewModel.listarSubgrupoCommand.running
            ? buildLoadingIndicator()
            : viewModel.obterPorIdCommand.completed &&
                  viewModel.listarSubgrupoCommand.completed
            ? _buildDropdownFieldSubgrupo(viewModel)
            : buildLoadingIndicator(),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDropdownFieldSubgrupo(ProdutoManterUiState viewModel) {
    viewModel.selectedSubgrupo = viewModel.subgrupos?.firstWhere(
      (element) => element.id == viewModel.produto?.subgrupoId?.toInt(),
      orElse: () =>
          ProdutoSubgrupoResponse(id: -1, descricaoSubgrupo: 'Default'),
    );

    if (viewModel.selectedSubgrupo?.id == -1) {
      viewModel.selectedSubgrupo = null;
    }

    return CustomDropdownButtonFormField<ProdutoSubgrupoResponse>(
      hint: 'Selecione um Subgrupo',
      items: viewModel.subgrupos ?? [],
      itemLabelBuilder: (item) => item.descricaoSubgrupo,
      selectedValue: viewModel.selectedSubgrupo,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecione um Subgrupo.';
        }
        return null;
      },
      onChanged: (value) {
        viewModel.selectedSubgrupo = value;
      },
      onSaved: (value) {
        viewModel.selectedSubgrupo = value;
      },
    );
  }

  void _handleCancelarPressed() {
    context.pop();
  }

  void _handleSalvarPressed() {}
}
*/
