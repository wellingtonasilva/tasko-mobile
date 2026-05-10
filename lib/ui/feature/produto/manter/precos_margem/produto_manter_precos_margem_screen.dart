import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';

class ProdutoManterPrecosMargemScreen extends BaseScreen {
  final Function(String value) onPrevious;
  final Function(String value) onNext;

  const ProdutoManterPrecosMargemScreen({
    super.key,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  BaseScreenState<ProdutoManterPrecosMargemScreen> createState() =>
      _ProdutoManterPrecosMargemScreenState();
}

class _ProdutoManterPrecosMargemScreenState
    extends BaseScreenState<ProdutoManterPrecosMargemScreen> {
  @override
  Widget buildContent(BuildContext context) {
    return Container();
  }
}
