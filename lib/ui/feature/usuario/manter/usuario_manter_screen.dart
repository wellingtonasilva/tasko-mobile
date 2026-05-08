import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/custom_dropdown_button_form_field.dart';
import 'package:tasko_mobile/domain/usuario/request/atualizar_usuario_request.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/ui/feature/usuario/manter/usuario_manter_controllers.dart';
import 'package:tasko_mobile/ui/feature/usuario/manter/usuario_manter_ui_state.dart';
import 'package:tasko_mobile/ui/feature/usuario/manter/usuario_manter_view_model.dart';
import 'package:tasko_mobile/util/result.dart';

class UsuarioManterScreen extends BaseScreen {
  final int usuarioId;

  const UsuarioManterScreen({super.key, required this.usuarioId});

  @override
  BaseScreenState<UsuarioManterScreen> createState() =>
      _UsuarioManterScreenState();
}

class _UsuarioManterScreenState extends BaseScreenState<UsuarioManterScreen> {
  late final UsuarioManterControllers _controllers;
  late final int _usuarioId;

  @override
  void initState() {
    super.initState();

    _controllers = UsuarioManterControllers();
    _usuarioId = widget.usuarioId;

    final viewModel = ref.read(usuarioManterViewModelProvider.notifier);
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
    viewModel.onAdicionarSucesso = () {
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    };

    ref.read(usuarioManterViewModelProvider).listarVendedoresCommand.execute();

    ref
        .read(usuarioManterViewModelProvider)
        .obterPorIdCommand
        .execute(_usuarioId);
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(usuarioManterViewModelProvider);

    ref.listen<UsuarioManterUiState>(usuarioManterViewModelProvider, (
      previous,
      next,
    ) {
      if (next.usuario != null) {
        _controllers.updateFormFields(next.usuario!);
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
                          title: 'Manter Usuário',
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
                              buildTextField(_controllers.nomeCompleto),
                              buildTextField(_controllers.numeroTelefone),
                              buildTextField(
                                _controllers.nomeUsuario,
                                isReadOnly: true,
                              ),
                              Visibility(
                                visible: !viewModel.isAdmin,
                                child: Column(
                                  children: [
                                    _buildDropdownGrupo(viewModel),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: viewModel.indicadorAtivo,
                                          onChanged: (value) {
                                            ref
                                                .read(
                                                  usuarioManterViewModelProvider
                                                      .notifier,
                                                )
                                                .setIndicadorAtivo(
                                                  value ?? false,
                                                );
                                          },
                                        ),
                                        Text(
                                          'Ativo',
                                          style: kTestStyleMediumText14.copyWith(
                                            color:
                                                kColorStyleSecondinaryLight400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

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
                                context.pop();
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: CustomButtonPrimary(
                              label: 'Salvar',
                              onPressed: () {
                                _handleSalvarPressed(viewModel);
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

  Widget _buildDropdownGrupo(UsuarioManterUiState viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text('Vendedor'),
        const SizedBox(height: 10),
        viewModel.listarVendedoresCommand.running
            ? buildLoadingIndicator()
            : viewModel.obterPorIdCommand.completed &&
                  viewModel.listarVendedoresCommand.completed
            ? _buildDropdownFieldGrupo(viewModel)
            : buildLoadingIndicator(),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDropdownFieldGrupo(UsuarioManterUiState viewModel) {
    viewModel.selectedVendedor = viewModel.vendedores.firstWhere(
      (element) => element.id == viewModel.usuario?.vendedor?.id,
      orElse: () =>
          VendedorResponse(id: -1, empresaId: 0, nomeVendedor: 'Default'),
    );

    if (viewModel.selectedVendedor?.id == -1) {
      viewModel.selectedVendedor = null;
    }

    return CustomDropdownButtonFormField<VendedorResponse>(
      hint: 'Selecione um Vendedor',
      items: viewModel.vendedores ?? [],
      itemLabelBuilder: (item) => item.nomeVendedor ?? 'Sem nome',
      selectedValue: viewModel.selectedVendedor,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecione um Vendedor.';
        }
        return null;
      },
      onChanged: (value) {
        viewModel.selectedVendedor = value;
      },
      onSaved: (value) {
        viewModel.selectedVendedor = value;
      },
    );
  }

  void _handleSalvarPressed(UsuarioManterUiState viewModel) {
    if (_controllers.formKey.currentState?.validate() ?? false) {
      _controllers.formKey.currentState?.save();

      final viewModel = ref.read(usuarioManterViewModelProvider);

      final request = AtualizarUsuarioRequest(
        id: viewModel.usuario?.id ?? 0,
        nomeUsuario: _controllers.nomeUsuario.controller.text,
        vendedorId: viewModel.selectedVendedor?.id,
        nomeCompleto: _controllers.nomeCompleto.controller.text,
        numeroTelefone: _controllers.numeroTelefone.controller.text,
        indicadorAtivo: viewModel.indicadorAtivo,
      );

      ref.read(usuarioManterViewModelProvider).atualizarUsuarioCommand.execute((
        viewModel.usuario?.id ?? 0,
        request,
      ));
    }
  }
}
