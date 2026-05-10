import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/container/custom_configuracao_items_container.dart';
import 'package:tasko_mobile/common/widgets/custom_configuracao_item.dart';
import 'package:tasko_mobile/domain/common/configuracao.dart';
import 'package:tasko_mobile/ui/feature/configuracao/configuracao_controllers.dart';
import 'package:tasko_mobile/ui/feature/configuracao/configuracao_view_model.dart';

class ConfiguracaoScreen extends BaseScreen {
  const ConfiguracaoScreen({super.key});

  @override
  BaseScreenState<ConfiguracaoScreen> createState() =>
      _ConfiguracaoScreenState();
}

class _ConfiguracaoScreenState extends BaseScreenState<ConfiguracaoScreen> {
  late final ConfiguracaoControllers _controllers;
  String _searchQuery = '';

  @override
  bool get useScaffold => false;

  @override
  void initState() {
    super.initState();
    _controllers = ConfiguracaoControllers();
    _controllers.pesquisarConfiguracao.controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controllers.pesquisarConfiguracao.controller.removeListener(
      _onSearchChanged,
    );
    _controllers.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final nextQuery = _controllers.pesquisarConfiguracao.controller.text;
    if (nextQuery == _searchQuery) {
      return;
    }

    setState(() {
      _searchQuery = nextQuery;
    });
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
        body: RefreshIndicator(
          onRefresh: () async {
            //await viewModel.listarProdutosCommand.execute();
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
                        child: Text(
                          'Configurações',
                          style: kTestStyleBoldText24,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildTextField(
                          _controllers.pesquisarConfiguracao,
                          isShowHint: true,
                          topPadding: 0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 0.0,
                          bottom: 10.0,
                          left: 8.0,
                          right: 8.0,
                        ),
                        child: _buildCadastrosSection(),
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

  void _onConfiguracaoTap(String key) {
    debugPrint('Tapped on configuracao with key: $key');
    if (key == 'sincronizacao') {
      showSnackBar('Sincronização iniciada. Isso pode levar alguns segundos.');
      return;
    }
    context.push('/$key');
  }

  Widget _buildCadastrosSection() {
    final viewModel = ref.watch(configuracaoViewModelProvider);
    final normalizedQuery = _normalizeText(_searchQuery);

    Map<String, List<Configuracao>> filteredSections =
        viewModel.configuracaoSections;
    var isShowingNearestMatch = false;

    if (normalizedQuery.isNotEmpty) {
      final directMatches = <String, List<Configuracao>>{};

      for (final entry in viewModel.configuracaoSections.entries) {
        final matches = entry.value.where((configuracao) {
          return _normalizeText(configuracao.label).contains(normalizedQuery);
        }).toList();

        if (matches.isNotEmpty) {
          directMatches[entry.key] = matches;
        }
      }

      if (directMatches.isNotEmpty) {
        filteredSections = directMatches;
      } else {
        final nearestMatch = _findNearestMatch(
          query: normalizedQuery,
          sections: viewModel.configuracaoSections,
        );

        if (nearestMatch != null) {
          isShowingNearestMatch = true;
          filteredSections = {
            nearestMatch.key: [nearestMatch.value],
          };
        } else {
          filteredSections = {};
        }
      }
    }

    if (filteredSections.isEmpty) {
      return Text(
        'Nenhum resultado encontrado para "$_searchQuery".',
        style: kTestStyleRegularText14,
      );
    }

    final sectionWidgets = filteredSections.entries.map((entry) {
      return CustomConfiguracaoItemsContainer(
        label: entry.key,
        children: entry.value
            .asMap()
            .entries
            .map(
              (configEntry) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomConfiguracaoItem(
                    keyName: configEntry.value.key,
                    onTap: (key) => _onConfiguracaoTap(key),
                    label: configEntry.value.label,
                    value: configEntry.value.value,
                    prefixIcon: configEntry.value.prefixIcon != null
                        ? Container(
                            decoration: BoxDecoration(
                              color: kColorStylePrimary200,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 5.0,
                                bottom: 5.0,
                                left: 8.0,
                                right: 8.0,
                              ),
                              child: Icon(
                                configEntry.value.prefixIcon,
                                color:
                                    kColorStylePrimaryNeutralPaletteDarkDefault,
                              ),
                            ),
                          )
                        : null,
                    showDivider: configEntry.key < entry.value.length - 1,
                    showArrow: configEntry.value.showArrow,
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            )
            .toList(),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isShowingNearestMatch)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Sem correspondencia exata. Exibindo o item mais proximo.',
              style: kTestStyleRegularText14,
            ),
          ),
        ...sectionWidgets,
      ],
    );
  }

  String _normalizeText(String value) {
    return value
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[áàâãä]'), 'a')
        .replaceAll(RegExp(r'[éèêë]'), 'e')
        .replaceAll(RegExp(r'[íìîï]'), 'i')
        .replaceAll(RegExp(r'[óòôõö]'), 'o')
        .replaceAll(RegExp(r'[úùûü]'), 'u')
        .replaceAll(RegExp(r'ç'), 'c');
  }

  MapEntry<String, Configuracao>? _findNearestMatch({
    required String query,
    required Map<String, List<Configuracao>> sections,
  }) {
    MapEntry<String, Configuracao>? nearest;
    var nearestDistance = 1 << 30;

    for (final entry in sections.entries) {
      for (final configuracao in entry.value) {
        final label = _normalizeText(configuracao.label);
        final distance = _levenshteinDistance(query, label);

        if (distance < nearestDistance) {
          nearestDistance = distance;
          nearest = MapEntry(entry.key, configuracao);
        }
      }
    }

    return nearest;
  }

  int _levenshteinDistance(String source, String target) {
    if (source.isEmpty) {
      return target.length;
    }
    if (target.isEmpty) {
      return source.length;
    }

    final rows = source.length + 1;
    final cols = target.length + 1;
    final matrix = List.generate(rows, (_) => List.filled(cols, 0));

    for (var row = 0; row < rows; row++) {
      matrix[row][0] = row;
    }
    for (var col = 0; col < cols; col++) {
      matrix[0][col] = col;
    }

    for (var row = 1; row < rows; row++) {
      for (var col = 1; col < cols; col++) {
        final cost = source[row - 1] == target[col - 1] ? 0 : 1;
        matrix[row][col] = [
          matrix[row - 1][col] + 1,
          matrix[row][col - 1] + 1,
          matrix[row - 1][col - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[rows - 1][cols - 1];
  }
}
