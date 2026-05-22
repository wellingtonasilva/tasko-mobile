import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_request.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar_old/pedido_criar_rascunho_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';

class PedidoAdicionarUiState {
  final Command1<PedidoResponse, AdicionarPedidoRequest> criarRascunhoCommand;
  final Command1<PedidoResponse, AtualizarPedidoRascunhoArgs>
  atualizarRascunhoCommand;
  final Command0<void> confirmarCommand;
  final PedidoResponse? pedido;
  final VendedorResponse? vendedor;

  // Clientes
  final Command0<void> listarClienteCommand;
  List<ClienteResponse>? clientes;
  ClienteResponse? selectedCliente;

  // Produtos
  final Command0<void> listarProdutoCommand;
  List<ProdutoResponse>? produtos;
  // produtoId → quantidade
  final Map<int, double> carrinhoQuantidades;

  // Pagamento
  final String? formaPagamentoNome;
  final String? condicaoPagamentoNome;

  int get totalItens =>
      carrinhoQuantidades.values.fold(0, (sum, q) => sum + q.toInt());

  double get valorTotal {
    if (produtos == null || produtos!.isEmpty) return 0;
    double total = 0;
    for (final entry in carrinhoQuantidades.entries) {
      final idx = produtos!.indexWhere((p) => p.id == entry.key);
      if (idx < 0) {
        continue;
      }
      final produto = produtos![idx];
      total += (produto.precoSugerido ?? 0) * entry.value;
    }
    return total;
  }

  PedidoAdicionarUiState({
    required this.criarRascunhoCommand,
    required this.atualizarRascunhoCommand,
    required this.listarClienteCommand,
    required this.listarProdutoCommand,
    required this.confirmarCommand,
    this.clientes,
    this.selectedCliente,
    this.produtos,
    Map<int, double>? carrinhoQuantidades,
    this.vendedor,
    this.pedido,
    this.formaPagamentoNome,
    this.condicaoPagamentoNome,
  }) : carrinhoQuantidades = carrinhoQuantidades ?? {};

  PedidoAdicionarUiState copyWith({
    Command1<PedidoResponse, AdicionarPedidoRequest>? criarRascunhoCommand,
    Command1<PedidoResponse, AtualizarPedidoRascunhoArgs>?
    atualizarRascunhoCommand,
    Command0<void>? listarClienteCommand,
    List<ClienteResponse>? clientes,
    ClienteResponse? selectedCliente,
    bool clearSelectedCliente = false,
    Command0<void>? listarProdutoCommand,
    List<ProdutoResponse>? produtos,
    Map<int, double>? carrinhoQuantidades,
    VendedorResponse? vendedor,
    PedidoResponse? pedido,
    String? formaPagamentoNome,
    String? condicaoPagamentoNome,
    Command0<void>? confirmarCommand,
  }) {
    return PedidoAdicionarUiState(
      criarRascunhoCommand: criarRascunhoCommand ?? this.criarRascunhoCommand,
      atualizarRascunhoCommand:
          atualizarRascunhoCommand ?? this.atualizarRascunhoCommand,
      listarClienteCommand: listarClienteCommand ?? this.listarClienteCommand,
      clientes: clientes ?? this.clientes,
      selectedCliente: clearSelectedCliente
          ? null
          : selectedCliente ?? this.selectedCliente,
      listarProdutoCommand: listarProdutoCommand ?? this.listarProdutoCommand,
      produtos: produtos ?? this.produtos,
      carrinhoQuantidades: carrinhoQuantidades ?? this.carrinhoQuantidades,
      vendedor: vendedor ?? this.vendedor,
      pedido: pedido ?? this.pedido,
      formaPagamentoNome: formaPagamentoNome ?? this.formaPagamentoNome,
      condicaoPagamentoNome:
          condicaoPagamentoNome ?? this.condicaoPagamentoNome,
      confirmarCommand: confirmarCommand ?? this.confirmarCommand,
    );
  }
}
