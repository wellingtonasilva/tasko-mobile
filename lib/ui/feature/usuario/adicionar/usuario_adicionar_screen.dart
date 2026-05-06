import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/custom_dropdown_button_form_field.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_label.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_text_form_field.dart';
import 'package:tasko_mobile/domain/usuario/request/adicionar_usuario_request.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/ui/feature/usuario/adicionar/usuario_adicionar_controllers.dart';
import 'package:tasko_mobile/ui/feature/usuario/adicionar/usuario_adicionar_ui_state.dart';
import 'package:tasko_mobile/ui/feature/usuario/adicionar/usuario_adicionar_view_model.dart';
import 'package:tasko_mobile/util/result.dart';

class UsuarioAdicionarScreen extends BaseScreen {
  const UsuarioAdicionarScreen({super.key});

  @override
  BaseScreenState<UsuarioAdicionarScreen> createState() =>
      _UsuarioAdicionarScreenState();
}

class _UsuarioAdicionarScreenState
    extends BaseScreenState<UsuarioAdicionarScreen> {
  late final UsuarioAdicionarControllers _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = UsuarioAdicionarControllers();

    final viewModel = ref.read(usuarioAdicionarViewModelProvider.notifier);
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

    ref
        .read(usuarioAdicionarViewModelProvider)
        .listarVendedoresCommand
        .execute();
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(usuarioAdicionarViewModelProvider);

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
                          title: 'Adicionar Usuário',
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
                              buildTextField(_controllers.nomeUsuario),
                              const SizedBox(height: 10),
                              CustomLabel(labelText: 'Senha'),
                              const SizedBox(height: 10),
                              CustomTextFormField(
                                controller: _controllers.senha.controller,
                                labelText:
                                    _controllers.senha.labelText ?? 'Senha',
                                autofillHints: [AutofillHints.password],
                                validator: _controllers.senha.validator,
                              ),
                              const SizedBox(height: 20),
                              CustomLabel(labelText: 'Repetir Senha'),
                              const SizedBox(height: 10),
                              CustomTextFormField(
                                controller:
                                    _controllers.repetirSenha.controller,
                                labelText:
                                    _controllers.repetirSenha.labelText ??
                                    'Repetir Senha',
                                autofillHints: [AutofillHints.password],
                                validator: (context, val) {
                                  final senhaVal =
                                      _controllers.senha.controller.text;
                                  if (val == null || val.isEmpty) {
                                    return 'Por favor repita a Senha.';
                                  } else if (val != senhaVal) {
                                    return 'As senhas não coincidem.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              _buildDropdownGrupo(viewModel),
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
                                debugPrint('Cancelar pressed');
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

  Widget _buildDropdownGrupo(UsuarioAdicionarUiState viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text('Vendedor'),
        const SizedBox(height: 10),
        viewModel.listarVendedoresCommand.running
            ? buildLoadingIndicator()
            : viewModel.listarVendedoresCommand.completed
            ? _buildDropdownFieldGrupo(viewModel)
            : buildLoadingIndicator(),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDropdownFieldGrupo(UsuarioAdicionarUiState viewModel) {
    viewModel.selectedVendedor = null;

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

  void _handleSalvarPressed(UsuarioAdicionarUiState viewModel) {
    if (_controllers.formKey.currentState?.validate() ?? false) {
      _controllers.formKey.currentState?.save();

      final viewModel = ref.read(usuarioAdicionarViewModelProvider);

      final request = AdicionarUsuarioRequest(
        nomeUsuario: _controllers.nomeUsuario.controller.text,
        senha: _controllers.senha.controller.text,
        vendedorId: viewModel.selectedVendedor?.id,
        nomeCompleto: _controllers.nomeCompleto.controller.text,
        numeroTelefone: _controllers.numeroTelefone.controller.text,
      );

      ref
          .read(usuarioAdicionarViewModelProvider)
          .adicionarUsuarioCommand
          .execute(request);
    }
  }
}
