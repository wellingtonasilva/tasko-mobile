import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_label.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_textfield.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/step1_cliente/pedido_selecionar_cliente_controllers.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_item.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_line.dart';

class PedidoSelecionarClienteScreen extends BaseScreen {
  final Function(String cliente) onPrevious;
  final Function(String cliente) onNext;
  const PedidoSelecionarClienteScreen({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  BaseScreenState<PedidoSelecionarClienteScreen> createState() =>
      _PedidoSelecionarClienteScreenState();
}

class _PedidoSelecionarClienteScreenState
    extends BaseScreenState<PedidoSelecionarClienteScreen> {
  late PedidoSelecionarClienteControllers _controllers;
  int activeStep = 1;
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    _controllers = PedidoSelecionarClienteControllers();
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
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTituloBarDefault(title: 'Novo Pedido'),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,

                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomStepperItem(
                                    title: "Cliente",
                                    active: true,
                                  ),
                                  CustomStepperLine(),
                                  CustomStepperItem(
                                    title: "Produtos",
                                    active: false,
                                  ),
                                  CustomStepperLine(),
                                  CustomStepperItem(
                                    title: "Pagamento",
                                    active: false,
                                  ),
                                  CustomStepperLine(),
                                  CustomStepperItem(
                                    title: "Revisão",
                                    active: false,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              buildTextField(_controllers.pesquisaCliente),
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
                                widget.onPrevious(
                                  _controllers.pesquisaCliente.controller.text,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: CustomButtonPrimary(
                              label: 'Próximo',
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

  void _handleCancelarPressed() {}

  void _handleSalvarPressed() {
    //if (_controllers.formKey.currentState?.validate() ?? false) {
    // Salvar cliente selecionado no controller
    // _controllers.clienteSelecionado = _controllers.pesquisaCliente.controller.text;
    widget.onNext(_controllers.pesquisaCliente.controller.text);
    //}
  }

  Widget _stepItem(String title, bool active) {
    return Column(
      children: [
        Container(
          width: 15,
          height: 15, // igual ao _line
          alignment: Alignment.center,
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: active ? Colors.orange : Colors.grey[300],
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(title, style: kTestStyleRegularText14),
      ],
    );
  }

  Widget buildTextField(
    CustomFormFieldData field, {
    bool isDate = false,
    bool isReadOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          CustomLabel(labelText: field.labelText),
          const SizedBox(height: 10),
          CustomTextfield(
            controller: field.controller,
            validator: field.validator,
            prefixIcon: field.prefixIcon,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
