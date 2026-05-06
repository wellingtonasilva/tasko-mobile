import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/custom_dropdown_button_form_field.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_item.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_line.dart';
import 'package:tasko_mobile/domain/common/mes_ano.dart';
import 'package:tasko_mobile/ui/feature/vendedor/metas/vendedor_metas_view_model.dart';

class VendedorMetasResumoScreen extends BaseScreen {
  final Function(String value) onPrevious;
  final Function(String value) onNext;

  const VendedorMetasResumoScreen({
    super.key,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  BaseScreenState<VendedorMetasResumoScreen> createState() =>
      _VendedorMetasResumoScreenState();
}

class _VendedorMetasResumoScreenState
    extends BaseScreenState<VendedorMetasResumoScreen> {
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
                        child: CustomTituloBarDefault(
                          title: 'Resumo',
                          child: Text(
                            '(1/4)',
                            style: kTestStyleBoldText14.copyWith(
                              color: kColorStyleSecondinaryLight400,
                            ),
                          ),
                        ),
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
                                    title: "Resumo",
                                    active: true,
                                    textStyle: kTestStyleRegularText12,
                                  ),
                                  CustomStepperLine(),
                                  CustomStepperItem(
                                    title: "Financeiro",
                                    active: false,
                                    textStyle: kTestStyleRegularText12,
                                  ),
                                  CustomStepperLine(),
                                  CustomStepperItem(
                                    title: "Pedidos e\nClientes",
                                    active: false,
                                    textStyle: kTestStyleRegularText12,
                                  ),
                                  CustomStepperLine(),
                                  CustomStepperItem(
                                    title: "Comissão",
                                    active: false,
                                    textStyle: kTestStyleRegularText12,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildDropdownFieldGrupo(),
                                  SizedBox(height: 15),
                                  _buildMetaFinanceira(),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(child: _buildMetaPedidos()),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: _buildMetaClientesNovos(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  _buildEstimativaComissao(),
                                  SizedBox(height: 5),
                                ],
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
                              label: 'Voltar',
                              onPressed: () {
                                widget.onPrevious('Produto');
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: CustomButtonPrimary(
                              label: 'Próximo',
                              onPressed: () => widget.onNext('Produto'),
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

  Widget _buildEstimativaComissao() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Center(
                child: Image.asset(
                  'assets/images/pos_icon_money_tick.png',
                  width: 40,
                ),
              ),
              SizedBox(width: 10),
              Text(
                "Estimativa Comissão",
                style: kTestStyleMediumText16.copyWith(
                  color: kColorStyleSecondinaryDarkDefault,
                ),
              ),
            ],
          ),
          Center(
            child: Text(
              "R\$ 4.800,00",
              style: kTestStyleBoldText24.copyWith(
                color: kColorStylePrimaryNeutralPaletteDark500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaFinanceira() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Center(
                child: Image.asset(
                  'assets/images/pos_icon_money_tick.png',
                  color: kColorStylePrimaryNeutralPaletteDark500,
                  width: 35,
                ),
              ),
              SizedBox(width: 10),
              Text(
                "Meta Financeira",
                style: kTestStyleMediumText14.copyWith(
                  color: kColorStyleSecondinaryDarkDefault,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: Text("Meta", style: kTestStyleMediumText14)),
              Text("R\$ 50.000,00", style: kTestStyleBoldText18),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(child: Text("Atingido", style: kTestStyleMediumText14)),
              Text(
                "R\$ 32.000,00",
                style: kTestStyleBoldText18.copyWith(
                  color: kColorStylePrimaryNeutralPaletteDark500,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          _buildHorizontalGauge(),
        ],
      ),
    );
  }

  Widget _buildMetaPedidos() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Center(
                child: Image.asset(
                  'assets/images/pos_icon_document_text.png',
                  width: 30,
                ),
              ),
              SizedBox(width: 10),
              Text(
                "Pedidos",
                style: kTestStyleBoldText12.copyWith(
                  color: kColorStyleSecondinaryDarkDefault,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: Text("Meta", style: kTestStyleBoldText12)),
              Text("120", style: kTestStyleBoldText16),
            ],
          ),
          SizedBox(height: 1),
          Row(
            children: [
              Expanded(child: Text("Atingido", style: kTestStyleBoldText12)),
              Text(
                "85",
                style: kTestStyleBoldText16.copyWith(
                  color: kColorStylePrimaryNeutralPaletteDark500,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          _buildHorizontalGaugePedidos(),
        ],
      ),
    );
  }

  Widget _buildMetaClientesNovos() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Center(
                child: Image.asset(
                  'assets/images/pos_icon_people.png',
                  color: kColorStyleSuccessDark600,
                  width: 30,
                ),
              ),
              SizedBox(width: 10),
              Text(
                "Clientes Novos",
                style: kTestStyleBoldText12.copyWith(
                  color: kColorStyleSecondinaryDarkDefault,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: Text("Meta", style: kTestStyleBoldText12)),
              Text("120", style: kTestStyleBoldText16),
            ],
          ),
          SizedBox(height: 1),
          Row(
            children: [
              Expanded(child: Text("Atingido", style: kTestStyleBoldText12)),
              Text(
                "85",
                style: kTestStyleBoldText16.copyWith(
                  color: kColorStylePrimaryNeutralPaletteDark500,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          _buildHorizontalGaugeClientesNovos(),
        ],
      ),
    );
  }

  Widget _buildDropdownGrupo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        _buildDropdownFieldGrupo(),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDropdownFieldGrupo() {
    final viewModel = ref.read(vendedorMetasViewModelProvider.notifier);

    return CustomDropdownButtonFormField<MesAno>(
      hint: 'Selecione um Mês/Ano',
      items: viewModel.mesesAnos,
      itemLabelBuilder: (item) => item.descricaoMes,
      prefixIcon: Padding(
        padding: const EdgeInsetsDirectional.only(start: 12, end: 8),
        child: Icon(Icons.calendar_month, color: kColorStyleSecondinaryDark400),
      ),
      //selectedValue: viewModel.selectedGrupo,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecione um Mês/Ano.';
        }
        return null;
      },
      onChanged: (value) {
        viewModel.mesAnoSelecionado = value;
      },
      onSaved: (value) {
        viewModel.mesAnoSelecionado = value;
      },
    );
  }

  Widget _buildHorizontalGaugePedidos() {
    final double meta = 120;
    final double atingido = 85;
    final double percentual = (atingido / meta) * 100;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            width: 200,
            child: RotatedBox(
              quarterTurns: 1, // gira 90° → barra fica horizontal
              child: BarChart(
                BarChartData(
                  maxY: meta,
                  minY: 0,
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: meta,
                          width: 15,
                          color: Colors.grey.shade200, // fundo (restante)
                          borderRadius: BorderRadius.circular(8),
                          rodStackItems: [
                            BarChartRodStackItem(
                              0,
                              atingido,
                              kColorStyleInformationDarkDefault, // atingido
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  barTouchData: BarTouchData(enabled: false),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Text(
          "${percentual.floor().toStringAsFixed(0)}%",
          style: kTestStyleBoldText16.copyWith(
            color: kColorStyleInformationDarkDefault,
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalGaugeClientesNovos() {
    final double meta = 30;
    final double atingido = 18;
    final double percentual = (atingido / meta) * 100;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            width: 200,
            child: RotatedBox(
              quarterTurns: 1, // gira 90° → barra fica horizontal
              child: BarChart(
                BarChartData(
                  maxY: meta,
                  minY: 0,
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: meta,
                          width: 15,
                          color: Colors.grey.shade200, // fundo (restante)
                          borderRadius: BorderRadius.circular(8),
                          rodStackItems: [
                            BarChartRodStackItem(
                              0,
                              atingido,
                              kColorStyleSuccessDark600, // atingido
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  barTouchData: BarTouchData(enabled: false),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Text(
          "${percentual.floor().toStringAsFixed(0)}%",
          style: kTestStyleBoldText16.copyWith(
            color: kColorStyleSuccessDark600,
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalGauge() {
    final double meta = 50000;
    final double atingido = 32000;
    final double percentual = (atingido / meta) * 100;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            width: 200,
            child: RotatedBox(
              quarterTurns: 1, // gira 90° → barra fica horizontal
              child: BarChart(
                BarChartData(
                  maxY: meta,
                  minY: 0,
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: meta,
                          width: 20,
                          color: Colors.grey.shade200, // fundo (restante)
                          borderRadius: BorderRadius.circular(8),
                          rodStackItems: [
                            BarChartRodStackItem(
                              0,
                              atingido,
                              kColorStylePrimaryNeutralPaletteDark500, // atingido
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  barTouchData: BarTouchData(enabled: false),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Text(
          "${percentual.toStringAsFixed(0)}%",
          style: kTestStyleBoldText18.copyWith(
            color: kColorStylePrimaryNeutralPaletteDark500,
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart2() {
    final double meta = 50000;
    final double atingido = 32000;

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: meta * 1.2,
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: meta,
                  color: Colors.blue.shade300,
                  width: 40,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: atingido,
                  color: kColorStylePrimaryNeutralPaletteDark500,
                  width: 40,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return Text('Meta');
                    case 1:
                      return Text('Atingido');
                    default:
                      return Text('');
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
        ),
      ),
    );
  }
}
