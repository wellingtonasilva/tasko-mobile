import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/domain/grupo/request/atualizar_produto_grupo_request.dart';
import 'package:tasko_mobile/ui/feature/grupo/manter/grupo_manter_controllers.dart';
import 'package:tasko_mobile/ui/feature/grupo/manter/grupo_manter_view_model.dart';
import 'package:tasko_mobile/util/result.dart';

class GrupoManterScreen extends BaseScreen {
  final int grupoId;

  const GrupoManterScreen({super.key, required this.grupoId});

  @override
  BaseScreenState<GrupoManterScreen> createState() => _GrupoManterScreenState();
}

class _GrupoManterScreenState extends BaseScreenState<GrupoManterScreen> {
  late final GrupoManterControllers _controllers;
  int? _lastHydratedGrupoId;

  @override
  void initState() {
    super.initState();
    _controllers = GrupoManterControllers();

    final viewModel = ref.read(grupoManterViewModelProvider.notifier);
    viewModel.showSnackBar = (String message, Result result) {
      if (mounted) {
        if (result is Success) {
          showSnackBar(message);
        } else if (result is Failure) {
          showSnackBar(message, isError: true);
        }
      }
    };

    viewModel.onManterSucesso = () {
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

    ref.read(grupoManterViewModelProvider).obterPorIdCommand.execute((
      widget.grupoId,
    ));
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(grupoManterViewModelProvider);
    final grupoAtual = viewModel.grupo;
    if (grupoAtual != null && _lastHydratedGrupoId != grupoAtual.id) {
      _controllers.updateFormFields(grupoAtual);
      _lastHydratedGrupoId = grupoAtual.id;
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
                  key: _controllers.formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTituloBarDefault(
                          title: 'Manter Grupo',
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
                                _controllers.descricaoGrupo,
                                isMandatory: true,
                              ),
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

  void _handleCancelarPressed() {
    Navigator.of(context).pop();
  }

  void _handleSalvarPressed() {
    if (!(_controllers.formKey.currentState?.validate() ?? false)) return;

    final request = AtualizarProdutoGrupoRequest(
      id: widget.grupoId,
      descricaoGrupo: _controllers.descricaoGrupo.controller.text.trim(),
    );

    ref.read(grupoManterViewModelProvider).atualizarCommand.execute((
      request.id,
      request,
    ));
  }
}
