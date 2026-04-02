import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';

class ModuloPlaceholderScreen extends BaseScreen {
  const ModuloPlaceholderScreen({super.key, required this.title});

  final String title;

  @override
  BaseScreenState<ModuloPlaceholderScreen> createState() =>
      _ModuloPlaceholderScreenState();
}

class _ModuloPlaceholderScreenState
    extends BaseScreenState<ModuloPlaceholderScreen> {
  @override
  bool get useScaffold => false;

  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.construction, size: 48),
            const SizedBox(height: 12),
            Text(widget.title, style: kTestStyleBoldText24),
            const SizedBox(height: 8),
            Text(
              'Este modulo sera implementado nas proximas etapas do roadmap.',
              textAlign: TextAlign.center,
              style: kTestStyleRegularText14,
            ),
          ],
        ),
      ),
    );
  }
}
