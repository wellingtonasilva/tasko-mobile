import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_request.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_item_request.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_response.dart';
import 'package:tasko_mobile/util/command.dart';

typedef AtualizarPedidoRascunhoArgs = ({
  int pedidoId,
  AdicionarPedidoRequest request,
  List<AdicionarPedidoItemRequest> itens,
  String? formaPagamentoNome,
  String? condicaoPagamentoNome,
  String? pedidoStatusTipoNome,
  bool substituirItens,
});

class PedidoCriarRascunhoUiState {
  final Command1<PedidoResponse, AdicionarPedidoRequest> criarRascunhoCommand;
  final Command1<PedidoResponse, AtualizarPedidoRascunhoArgs>
  atualizarRascunhoCommand;
  final PedidoResponse? pedido;
  final bool isEdicao;

  const PedidoCriarRascunhoUiState({
    required this.criarRascunhoCommand,
    required this.atualizarRascunhoCommand,
    this.pedido,
    this.isEdicao = false,
  });

  PedidoCriarRascunhoUiState copyWith({
    Command1<PedidoResponse, AdicionarPedidoRequest>? criarRascunhoCommand,
    Command1<PedidoResponse, AtualizarPedidoRascunhoArgs>?
    atualizarRascunhoCommand,
    PedidoResponse? pedido,
    bool? isEdicao,
    bool clearPedido = false,
  }) {
    return PedidoCriarRascunhoUiState(
      criarRascunhoCommand: criarRascunhoCommand ?? this.criarRascunhoCommand,
      atualizarRascunhoCommand:
          atualizarRascunhoCommand ?? this.atualizarRascunhoCommand,
      pedido: clearPedido ? null : pedido ?? this.pedido,
      isEdicao: isEdicao ?? this.isEdicao,
    );
  }
}
