import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/common/core/vendedor_sessao_provider.dart';
import 'package:tasko_mobile/data/repositories/cliente/cliente_repository_hybrid.dart';
import 'package:tasko_mobile/data/repositories/pedido/pedido_repository_hybrid.dart';
import 'package:tasko_mobile/data/repositories/produto/produto_repository_hybrid.dart';
import 'package:tasko_mobile/data/service/condicao_pagamento_service.dart';
import 'package:tasko_mobile/data/service/forma_pagamento_service.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/domain/pedido/pedido_calculator.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_request.dart';
import 'package:tasko_mobile/domain/pedido/response/condicao_pagamento_response.dart';
import 'package:tasko_mobile/domain/pedido/response/forma_pagamento_response.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/pedido_criar_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class PedidoCriarViewModel extends Notifier<PedidoCriarUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onSalvarSucesso;

  @override
  PedidoCriarUiState build() {
    return PedidoCriarUiState(
      clientes: [],
      produtos: [],
      itens: [],
      formasPagamento: [],
      condicoesPagamento: [],
      subtotal: 0,
      valorDesconto: 0,
      valorFrete: 0,
      valorTotal: 0,
      carregarDadosCommand: Command0<void>(_carregarDados),
      salvarPedidoCommand: Command1<PedidoResponse, void>(_salvarPedido),
    );
  }

  int? get _vendedorSelecionadoId => ref.read(vendedorSelecionadoIdProvider);

  Future<Result<void>> _carregarDados() async {
    final clienteRepo = ref.read(clienteRepositoryHybridProvider);
    final produtoRepo = ref.read(produtoRepositoryHybridProvider);
    final formaService = ref.read(formaPagamentoServiceProvider);
    final condicaoService = ref.read(condicaoPagamentoServiceProvider);

    final clienteResult = await clienteRepo.listar(
      vendedorId: _vendedorSelecionadoId,
    );
    final produtoResult = await produtoRepo.listar();
    final formaResult = await formaService.listar();
    final condicaoResult = await condicaoService.listar();

    state = state.copyWith(
      clientes: clienteResult is Success<List<ClienteResponse>>
          ? clienteResult.value
          : [],
      produtos: produtoResult is Success<List<ProdutoResponse>>
          ? produtoResult.value
          : [],
      formasPagamento: formaResult is Success<List<FormaPagamentoResponse>>
          ? formaResult.value
          : [],
      condicoesPagamento:
          condicaoResult is Success<List<CondicaoPagamentoResponse>>
          ? condicaoResult.value
          : [],
    );

    return Result.success(null);
  }

  void selecionarCliente(ClienteResponse? cliente) {
    state = state.copyWith(
      clienteSelecionado: cliente,
      clearCliente: cliente == null,
    );
  }

  void adicionarItem(PedidoItemEntry item) {
    final novosItens = [...state.itens, item];
    _recalcular(novosItens);
  }

  void removerItem(int index) {
    final novosItens = [...state.itens]..removeAt(index);
    _recalcular(novosItens);
  }

  void selecionarFormaPagamento(FormaPagamentoResponse? forma) {
    state = state.copyWith(
      formaPagamentoSelecionada: forma,
      clearFormaPagamento: forma == null,
    );
  }

  void selecionarCondicaoPagamento(CondicaoPagamentoResponse? condicao) {
    state = state.copyWith(
      condicaoPagamentoSelecionada: condicao,
      clearCondicaoPagamento: condicao == null,
    );
  }

  void atualizarDesconto(double percentual) {
    final desconto = PedidoCalculator.calcularDescontoValor(
      subtotal: state.subtotal,
      percentualDesconto: percentual,
    );
    final total = PedidoCalculator.calcularTotal(
      subtotal: state.subtotal,
      valorDesconto: desconto,
      valorFrete: state.valorFrete,
    );
    state = state.copyWith(valorDesconto: desconto, valorTotal: total);
  }

  void atualizarFrete(double frete) {
    final total = PedidoCalculator.calcularTotal(
      subtotal: state.subtotal,
      valorDesconto: state.valorDesconto,
      valorFrete: frete,
    );
    state = state.copyWith(valorFrete: frete, valorTotal: total);
  }

  void _recalcular(List<PedidoItemEntry> itens) {
    // Build temporary PedidoItemResponse list just for subtotal calc
    final subtotal = itens.fold<double>(
      0,
      (sum, item) => sum + item.valorTotal,
    );
    final rounded = (subtotal * 100).roundToDouble() / 100;
    final total = PedidoCalculator.calcularTotal(
      subtotal: rounded,
      valorDesconto: state.valorDesconto,
      valorFrete: state.valorFrete,
    );
    state = state.copyWith(itens: itens, subtotal: rounded, valorTotal: total);
  }

  Future<Result<PedidoResponse>> _salvarPedido(void _) async {
    if (state.clienteSelecionado == null) {
      final Result<PedidoResponse> result = Result.failure([
        'Selecione um cliente',
      ]);
      showSnackBar?.call('Selecione um cliente', result);
      return result;
    }

    if (state.itens.isEmpty) {
      final Result<PedidoResponse> result = Result.failure([
        'Adicione pelo menos um item',
      ]);
      showSnackBar?.call('Adicione pelo menos um item', result);
      return result;
    }

    final now = DateTime.now();
    final uuidOffline = 'ped-${now.toUtc().microsecondsSinceEpoch}';

    final request = AdicionarPedidoRequest(
      clienteId: state.clienteSelecionado!.id,
      vendedorId: _vendedorSelecionadoId ?? 0,
      pedidoStatusTipoId: 1,
      dataPedido: now.toUtc().toIso8601String(),
      dataEntregaPrevista: null,
      observacao: null,
      subtotal: state.subtotal,
      percentualDesconto: null,
      valorDesconto: state.valorDesconto,
      valorFrete: state.valorFrete,
      valorTotal: state.valorTotal,
      formaPagamentoId: state.formaPagamentoSelecionada?.id,
      condicaoPagamentoId: state.condicaoPagamentoSelecionada?.id,
      latitude: null,
      longitude: null,
      uuidOffline: uuidOffline,
    );

    final itemRequests = state.itens.map((e) => e.toRequest()).toList();

    final repository = ref.read(pedidoRepositoryHybridProvider);
    final result = await repository.adicionar(
      request,
      itens: itemRequests,
      formaPagamentoNome:
          state.formaPagamentoSelecionada?.descricaoFormaPagamento,
      condicaoPagamentoNome:
          state.condicaoPagamentoSelecionada?.descricaoCondicaoPagamento,
      pedidoStatusTipoNome: 'Rascunho',
    );

    if (result is Success<PedidoResponse>) {
      showSnackBar?.call('Pedido criado com sucesso!', result);
      onSalvarSucesso?.call();
    } else if (result is Failure<PedidoResponse>) {
      showSnackBar?.call(result.errors?[0] ?? 'Erro ao criar pedido', result);
    }

    return result;
  }
}

final pedidoCriarViewModelProvider =
    NotifierProvider<PedidoCriarViewModel, PedidoCriarUiState>(
      PedidoCriarViewModel.new,
    );
