import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/domain/vendedor/request/atualizar_vendedor_supervisor_request.dart';
import 'package:tasko_mobile/ui/feature/supervisor/manter/supervisor_manter_controllers.dart';
import 'package:tasko_mobile/ui/feature/supervisor/manter/supervisor_manter_ui_state.dart';
import 'package:tasko_mobile/ui/feature/supervisor/manter/supervisor_manter_view_model.dart';
import 'package:tasko_mobile/util/result.dart';

class SupervisorManterScreen extends BaseScreen {
  final int id;

  const SupervisorManterScreen({super.key, required this.id});

  @override
  BaseScreenState<SupervisorManterScreen> createState() =>
      _SupervisorManterScreenState();
}

class _SupervisorManterScreenState
    extends BaseScreenState<SupervisorManterScreen> {
  late final SupervisorManterControllers _controllers;
  int? _lastHydratedSupervisorId;

  @override
  void initState() {
    super.initState();
    _controllers = SupervisorManterControllers();

    final viewModel = ref.read(supervisorManterViewModelProvider.notifier);
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

    ref.read(supervisorManterViewModelProvider).obterPorIdCommand.execute((
      widget.id,
    ));
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(supervisorManterViewModelProvider);
    final supervisorAtual = viewModel.supervisor;
    if (supervisorAtual != null &&
        _lastHydratedSupervisorId != supervisorAtual.id) {
      _controllers.updateFormFields(supervisorAtual);
      _lastHydratedSupervisorId = supervisorAtual.id;
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
                          title: 'Manter Supervisor',
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
                                _controllers.nomeSupervisor,
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
    Navigator.of(context).pop(false);
  }

  void _handleSalvarPressed() {
    if (!(_controllers.formKey.currentState?.validate() ?? false)) return;

    final request = AtualizarVendedorSupervisorRequest(
      nomeSupervisor: _controllers.nomeSupervisor.controller.text.trim(),
      id: ref.read(supervisorManterViewModelProvider).supervisor?.id ?? 0,
    );

    ref.read(supervisorManterViewModelProvider).atualizarCommand.execute((
      request.id,
      request,
    ));
  }
}
