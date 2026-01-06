import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BaseScreen extends ConsumerStatefulWidget {
  const BaseScreen({super.key});
}

abstract class BaseScreenState<T extends BaseScreen> extends ConsumerState<T> {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Exibe o indicador de loading
  void showLoading() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
  }

  /// Esconde o indicador de loading
  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  /// Exibe uma mensagem de erro
  void showError(String message) {
    setState(() {
      _errorMessage = message;
      _isLoading = false;
    });
  }

  /// Limpa a mensagem de erro
  void clearError() {
    setState(() {
      _errorMessage = null;
    });
  }

  /// Exibe um SnackBar com mensagem
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: isError
                ? kColorStyleErrorLight400
                : kColorStyleSuccessDark600,
          ),
        ),
        backgroundColor: isError
            ? kColorStyleErrorDark700
            : kColorStyleSuccessLight200,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Fechar',
          textColor: isError
              ? kColorStyleErrorLight400
              : kColorStyleSuccessDark600,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Método abstrato que deve ser implementado pelas telas filhas
  /// Retorna o conteúdo principal da tela
  Widget buildContent(BuildContext context);

  /// Permite customizar o AppBar (opcional)
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  /// Permite customizar o FloatingActionButton (opcional)
  Widget? buildFloatingActionButton(BuildContext context) => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Stack(
        children: [
          // Conteúdo principal
          buildContent(context),

          // Mensagem de erro (se houver)
          if (_errorMessage != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                color: kColorStyleErrorLight200,
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: clearError,
                    ),
                  ],
                ),
              ),
            ),

          // Indicador de loading
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  Widget buildLoadingIndicator() {
    return const Center(
      child: SizedBox(
        width: 24.0,
        height: 24.0,
        child: CircularProgressIndicator(
          color: kColorStylePrimaryNeutralPaletteDarkDefault,
        ),
      ),
    );
  }
}
