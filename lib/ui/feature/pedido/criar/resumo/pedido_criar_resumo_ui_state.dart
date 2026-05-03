import 'package:tasko_mobile/domain/pedido/response/pedido_response.dart';
import 'package:tasko_mobile/util/command.dart';

class PedidoCriarResumoUiState {
  final PedidoResponse? rascunho;
  final Command0<void> confirmarCommand;
  final bool isEdicao;

  const PedidoCriarResumoUiState({
    required this.confirmarCommand,
    this.rascunho,
    this.isEdicao = false,
  });

  PedidoCriarResumoUiState copyWith({
    PedidoResponse? rascunho,
    Command0<void>? confirmarCommand,
    bool? isEdicao,
  }) {
    return PedidoCriarResumoUiState(
      confirmarCommand: confirmarCommand ?? this.confirmarCommand,
      rascunho: rascunho ?? this.rascunho,
      isEdicao: isEdicao ?? this.isEdicao,
    );
  }
}
