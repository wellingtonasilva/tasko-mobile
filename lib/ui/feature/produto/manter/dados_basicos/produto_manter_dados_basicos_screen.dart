import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';

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
  @override
  Widget buildContent(BuildContext context) {
    return Container();
  }
}
