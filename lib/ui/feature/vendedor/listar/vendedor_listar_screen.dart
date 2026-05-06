import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/container/custom_container_default.dart';
import 'package:tasko_mobile/common/widgets/dashboard/custom_dashboard_card_default.dart';
import 'package:tasko_mobile/common/widgets/list/custom_list_view.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/ui/feature/vendedor/listar/vendedor_listar_controllers.dart';
import 'package:tasko_mobile/ui/feature/vendedor/listar/vendedor_listar_view_model.dart';
import 'package:tasko_mobile/ui/feature/vendedor/listar/widgets/vendedor_list_card.dart';
import 'package:tasko_mobile/util/result.dart';

class VendedorListarScreen extends BaseScreen {
  const VendedorListarScreen({super.key});

  @override
  BaseScreenState<VendedorListarScreen> createState() =>
      _VendedorListarScreenState();
}

class _VendedorListarScreenState extends BaseScreenState<VendedorListarScreen> {
  late final VendedorListarControllers _controllers;

  List<Color> gradientColors = [
    kColorStyleErrorLight100,
    kColorStylePrimaryNeutralPaletteDark500,
  ];

  @override
  void initState() {
    super.initState();
    _controllers = VendedorListarControllers();

    final viewModel = ref.read(vendedorListarViewModelProvider.notifier);
    viewModel.showSnackBar = (String message, Result result) {
      if (mounted) {
        if (result is Success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: kColorStyleSuccessDarkDefault,
            ),
          );
        } else if (result is Failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: kColorStyleErrorDarkDefault,
            ),
          );
        }
      }
    };
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(vendedorListarViewModelProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: kColorStylePrimary100,
        body: RefreshIndicator(
          onRefresh: () async {
            return viewModel.listarVendedoresCommand.execute();
          },
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(color: kColorStylePrimary100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Vendedores', style: kTestStyleBoldText24),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButtonPrimary(
                          label: 'Adicionar Vendedor',
                          onPressed: () async {
                            final adicionado = await context.pushNamed<bool>(
                              'vendedores-adicionar',
                            );
                            if (adicionado == true) {
                              ref
                                  .read(vendedorListarViewModelProvider)
                                  .listarVendedoresCommand
                                  .execute();
                            }
                          },
                          trailingIcon: Icons.add,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildTextField(
                          _controllers.pesquisarVendedor,
                          isShowHint: true,
                          topPadding: 0,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            viewModel.listarVendedoresCommand.running
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: viewModel.vendedores.length,
                                    itemBuilder: (context, index) {
                                      final vendedor =
                                          viewModel.vendedores[index];
                                      return VendedorListCard(
                                        vendedor: vendedor,
                                        onTap: () async {
                                          final atualizado = await context
                                              .pushNamed<bool>(
                                                'vendedores-manter',
                                                pathParameters: {
                                                  'id': vendedor.id.toString(),
                                                },
                                              );
                                          if (atualizado == true) {
                                            ref
                                                .read(
                                                  vendedorListarViewModelProvider,
                                                )
                                                .listarVendedoresCommand
                                                .execute();
                                          }
                                        },
                                      );
                                    },
                                  ),
                          ],
                        ),
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

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    String text = switch (value.toInt()) {
      2 => 'MAR',
      5 => 'JUN',
      8 => 'SEP',
      _ => '',
    };
    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 15);
    String text = switch (value.toInt()) {
      1 => '10K',
      3 => '30k',
      5 => '50k',
      _ => '',
    };

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(color: Color(0xff37434d), strokeWidth: 1);
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(color: Color(0xff37434d), strokeWidth: 1);
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(
                begin: gradientColors[0],
                end: gradientColors[1],
              ).lerp(0.2)!,
              ColorTween(
                begin: gradientColors[0],
                end: gradientColors[1],
              ).lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(
                  begin: gradientColors[0],
                  end: gradientColors[1],
                ).lerp(0.2)!.withValues(alpha: 0.1),
                ColorTween(
                  begin: gradientColors[0],
                  end: gradientColors[1],
                ).lerp(0.2)!.withValues(alpha: 0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _excluirVendedor(
    int id,
    int indexRemovido,
    VendedorResponse vendedorRemovido,
  ) async {
    final viewModel = ref.read(vendedorListarViewModelProvider);
    // Remover o item da lista visualmente
    setState(() {
      viewModel.vendedores.removeAt(indexRemovido);
    });

    await viewModel.excluirVendedorCommand.execute(id);
    if (viewModel.excluirVendedorCommand.result is Failure) {
      setState(() {
        viewModel.vendedores.insert(indexRemovido, vendedorRemovido);
      });
    }
  }
}
