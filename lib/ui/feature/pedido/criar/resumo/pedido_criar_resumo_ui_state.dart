import 'package:tasko_mobile/domain/pedido/response/pedido_response.dart';
import 'package:tasko_mobile/util/command.dart';

class PedidoCriarResumoUiState {
  final PedidoResponse? rascunho;
  final Command0<void> confirmarCommand;

  const PedidoCriarResumoUiState({
    required this.confirmarCommand,
    this.rascunho,
  });

  PedidoCriarResumoUiState copyWith({
    PedidoResponse? rascunho,
    Command0<void>? confirmarCommand,
  }) {
    return PedidoCriarResumoUiState(
      confirmarCommand: confirmarCommand ?? this.confirmarCommand,
      rascunho: rascunho ?? this.rascunho,
    );
  }
}
