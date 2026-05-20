import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_request.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/util/command.dart';

class PedidoAdicionarUiState {
  final Command1<PedidoResponse, AdicionarPedidoRequest> criarRascunhoCommand;

  // Clientes
  final Command0<void> listarClienteCommand;
  List<ClienteResponse>? clientes;
  ClienteResponse? selectedCliente;

  // Produtos
  final Command0<void> listarProdutoCommand;
  List<ProdutoResponse>? produtos;
  // produtoId → quantidade
  final Map<int, double> carrinhoQuantidades;

  PedidoAdicionarUiState({
    required this.criarRascunhoCommand,
    required this.listarClienteCommand,
    required this.listarProdutoCommand,
    this.clientes,
    this.selectedCliente,
    this.produtos,
    Map<int, double>? carrinhoQuantidades,
  }) : carrinhoQuantidades = carrinhoQuantidades ?? {};

  PedidoAdicionarUiState copyWith({
    Command1<PedidoResponse, AdicionarPedidoRequest>? criarRascunhoCommand,
    Command0<void>? listarClienteCommand,
    List<ClienteResponse>? clientes,
    ClienteResponse? selectedCliente,
    bool clearSelectedCliente = false,
    Command0<void>? listarProdutoCommand,
    List<ProdutoResponse>? produtos,
    Map<int, double>? carrinhoQuantidades,
  }) {
    return PedidoAdicionarUiState(
      criarRascunhoCommand: criarRascunhoCommand ?? this.criarRascunhoCommand,
      listarClienteCommand: listarClienteCommand ?? this.listarClienteCommand,
      clientes: clientes ?? this.clientes,
      selectedCliente: clearSelectedCliente
          ? null
          : selectedCliente ?? this.selectedCliente,
      listarProdutoCommand: listarProdutoCommand ?? this.listarProdutoCommand,
      produtos: produtos ?? this.produtos,
      carrinhoQuantidades: carrinhoQuantidades ?? this.carrinhoQuantidades,
    );
  }
}
