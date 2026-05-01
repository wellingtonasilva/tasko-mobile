import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_item_request.dart';
import 'package:tasko_mobile/domain/pedido/response/condicao_pagamento_response.dart';
import 'package:tasko_mobile/domain/pedido/response/forma_pagamento_response.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/util/command.dart';

class PedidoItemEntry {
  final ProdutoResponse produto;
  final double quantidade;
  final double precoUnitario;
  final double? percentualDesconto;
  final double? valorDesconto;
  final double valorTotal;

  PedidoItemEntry({
    required this.produto,
    required this.quantidade,
    required this.precoUnitario,
    this.percentualDesconto,
    this.valorDesconto,
    required this.valorTotal,
  });

  AdicionarPedidoItemRequest toRequest({int pedidoId = 0}) {
    return AdicionarPedidoItemRequest(
      pedidoId: pedidoId,
      produtoId: produto.id,
      quantidade: quantidade,
      precoUnitario: precoUnitario,
      percentualDesconto: percentualDesconto,
      valorDesconto: valorDesconto ?? 0,
      valorTotal: valorTotal,
    );
  }
}

class PedidoCriarUiState {
  final List<ClienteResponse> clientes;
  final ClienteResponse? clienteSelecionado;
  final List<ProdutoResponse> produtos;
  final List<PedidoItemEntry> itens;
  final List<FormaPagamentoResponse> formasPagamento;
  final List<CondicaoPagamentoResponse> condicoesPagamento;
  final FormaPagamentoResponse? formaPagamentoSelecionada;
  final CondicaoPagamentoResponse? condicaoPagamentoSelecionada;
  final double subtotal;
  final double valorDesconto;
  final double valorFrete;
  final double valorTotal;
  final List<VendedorResponse> vendedores;
  final VendedorResponse? vendedorSelecionado;
  final Command0<void> carregarDadosCommand;
  final Command1<PedidoResponse, void> salvarPedidoCommand;

  PedidoCriarUiState({
    required this.clientes,
    this.clienteSelecionado,
    required this.produtos,
    required this.itens,
    required this.formasPagamento,
    required this.condicoesPagamento,
    this.formaPagamentoSelecionada,
    this.condicaoPagamentoSelecionada,
    required this.subtotal,
    required this.valorDesconto,
    required this.valorFrete,
    required this.valorTotal,
    required this.vendedores,
    this.vendedorSelecionado,
    required this.carregarDadosCommand,
    required this.salvarPedidoCommand,
  });

  PedidoCriarUiState copyWith({
    List<ClienteResponse>? clientes,
    ClienteResponse? clienteSelecionado,
    bool clearCliente = false,
    List<ProdutoResponse>? produtos,
    List<PedidoItemEntry>? itens,
    List<FormaPagamentoResponse>? formasPagamento,
    List<CondicaoPagamentoResponse>? condicoesPagamento,
    FormaPagamentoResponse? formaPagamentoSelecionada,
    bool clearFormaPagamento = false,
    CondicaoPagamentoResponse? condicaoPagamentoSelecionada,
    bool clearCondicaoPagamento = false,
    double? subtotal,
    double? valorDesconto,
    double? valorFrete,
    double? valorTotal,
    List<VendedorResponse>? vendedores,
    VendedorResponse? vendedorSelecionado,
    bool clearVendedor = false,
    Command0<void>? carregarDadosCommand,
    Command1<PedidoResponse, void>? salvarPedidoCommand,
  }) {
    return PedidoCriarUiState(
      clientes: clientes ?? this.clientes,
      clienteSelecionado: clearCliente
          ? null
          : (clienteSelecionado ?? this.clienteSelecionado),
      produtos: produtos ?? this.produtos,
      itens: itens ?? this.itens,
      formasPagamento: formasPagamento ?? this.formasPagamento,
      condicoesPagamento: condicoesPagamento ?? this.condicoesPagamento,
      formaPagamentoSelecionada: clearFormaPagamento
          ? null
          : (formaPagamentoSelecionada ?? this.formaPagamentoSelecionada),
      condicaoPagamentoSelecionada: clearCondicaoPagamento
          ? null
          : (condicaoPagamentoSelecionada ?? this.condicaoPagamentoSelecionada),
      subtotal: subtotal ?? this.subtotal,
      valorDesconto: valorDesconto ?? this.valorDesconto,
      valorFrete: valorFrete ?? this.valorFrete,
      valorTotal: valorTotal ?? this.valorTotal,
      vendedores: vendedores ?? this.vendedores,
      vendedorSelecionado: clearVendedor
          ? null
          : (vendedorSelecionado ?? this.vendedorSelecionado),
      carregarDadosCommand: carregarDadosCommand ?? this.carregarDadosCommand,
      salvarPedidoCommand: salvarPedidoCommand ?? this.salvarPedidoCommand,
    );
  }
}
