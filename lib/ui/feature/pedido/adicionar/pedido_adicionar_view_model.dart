import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/common/core/auth_persistence.dart';
import 'package:tasko_mobile/data/repositories/cliente/cliente_repository_hybrid.dart';
import 'package:tasko_mobile/data/repositories/condicao_pagamento/condicao_pagamento_repository_hybrid.dart';
import 'package:tasko_mobile/data/repositories/forma_pagamento/forma_pagamento_repository_hybrid.dart';
import 'package:tasko_mobile/data/repositories/pedido/pedido_repository_hybrid.dart';
import 'package:tasko_mobile/data/repositories/produto/produto_repository_hybrid.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/domain/condicao_pagamento/response/condicao_pagamento_response.dart';
import 'package:tasko_mobile/domain/forma_pagamento/response/forma_pagamento_response.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_request.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_item_response.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/ui/feature/pedido/adicionar/pedido_adicionar_ui_state.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar_old/pagamento/pedido_criar_pagamento_screen.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar_old/pedido_criar_rascunho_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class PedidoAdicionarViewModel extends Notifier<PedidoAdicionarUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;
  void Function()? onAdicionarSucesso;
  void Function()? onConfirmado;

  @override
  PedidoAdicionarUiState build() {
    return PedidoAdicionarUiState(
      criarRascunhoCommand: Command1<PedidoResponse, AdicionarPedidoRequest>(
        _criarRascunho,
      ),
      atualizarRascunhoCommand:
          Command1<PedidoResponse, AtualizarPedidoRascunhoArgs>(
            _atualizarRascunho,
          ),
      listarClienteCommand: Command0<void>(_listarClientes),
      listarProdutoCommand: Command0<void>(_listarProdutos),
      confirmarCommand: Command0<void>(_confirmar),
      listarFormaPagamentoCommand: Command0<void>(_listarFormasPagamento),
      listarCondicaoPagamentoCommand: Command0<void>(_listarCondicoesPagamento),
    );
  }

  Future<Result<PedidoResponse>> _criarRascunho(
    AdicionarPedidoRequest request,
  ) async {
    onStartEvent?.call();
    final usuarioLoginResponse = await ref
        .read(authLocalStorageProvider)
        .getUsuarioLoginResponse();
    final vendedor = usuarioLoginResponse?.vendedor;
    state = state.copyWith(vendedor: vendedor);

    final result = await ref
        .read(pedidoRepositoryHybridProvider)
        .criarRascunho(request.copyWith(vendedorId: vendedor?.id));

    if (result is Success<PedidoResponse>) {
      state = state.copyWith(pedido: result.value);
    } else if (result is Failure<PedidoResponse>) {
      showSnackBar?.call(
        result.errors?[0] ?? 'Erro ao criar rascunho do pedido',
        result,
      );
    }

    onFinishEvent?.call();
    return result;
  }

  Future<Result<PedidoResponse>> _atualizarRascunho(
    AtualizarPedidoRascunhoArgs args,
  ) async {
    onStartEvent?.call();

    final result = await ref
        .read(pedidoRepositoryHybridProvider)
        .atualizarRascunho(
          args.pedidoId,
          args.request,
          itens: args.itens,
          formaPagamentoNome: args.formaPagamentoNome,
          condicaoPagamentoNome: args.condicaoPagamentoNome,
          pedidoStatusTipoNome: args.pedidoStatusTipoNome,
          substituirItens: args.substituirItens,
        );

    if (result is Success<PedidoResponse>) {
      state = state.copyWith(pedido: result.value);
    } else if (result is Failure<PedidoResponse>) {
      showSnackBar?.call(
        result.errors?[0] ?? 'Erro ao atualizar rascunho do pedido',
        result,
      );
    }

    onFinishEvent?.call();
    return result;
  }

  Future<Result<PedidoResponse>> _confirmar() async {
    onStartEvent?.call();

    return Future.value(
      Failure<PedidoResponse>(['Função de confirmação ainda não implementada']),
    );
  }

  // ---------------------------------------------------------------------------
  // Formas de Pagamento
  // ---------------------------------------------------------------------------
  Future<Result<List<FormaPagamento>>> _listarFormasPagamento() async {
    onStartEvent?.call();
    final result = await ref
        .read(formaPagamentoRepositoryHybridProvider)
        .listarCondicoesPagamentoAssociadas();
    if (result is Success<List<FormaPagamentoResponse>>) {
      state = state.copyWith(
        formasPagamento: convertToFormaPagamentoList(result.value),
      );
    } else if (result is Failure<List<FormaPagamentoResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();

    return state.formasPagamento != null
        ? Success<List<FormaPagamento>>(state.formasPagamento!)
        : Failure<List<FormaPagamento>>(['No payment methods available']);
  }

  List<FormaPagamento> convertToFormaPagamentoList(
    List<FormaPagamentoResponse> responses,
  ) {
    return responses
        .map(
          (f) => FormaPagamento(
            id: f.id,
            nome: f.descricaoFormaPagamento ?? '',
            icone: getIconeForFormaPagamento(f.id),
          ),
        )
        .toList();
  }

  String getIconeForFormaPagamento(int formaPagamentoId) {
    switch (formaPagamentoId) {
      case 1: // Dinheiro
        return 'assets/images/pos_icon_money.svg';
      case 2: // Pix
        return 'assets/images/pos_icon_pix.svg';
      case 3: // Cartão de crédito
        return 'assets/images/pos_icon_credit_card.svg';
      case 4: // Cartão de débito
        return 'assets/images/pos_icon_credit_card.svg';
      default:
        return 'assets/images/pos_icon_money.svg'; // Ícone padrão
    }
  }

  // ---------------------------------------------------------------------------
  // Condição de Pagamento
  // ---------------------------------------------------------------------------
  Future<Result<List<CondicaoPagamentoResponse>>>
  _listarCondicoesPagamento() async {
    onStartEvent?.call();
    final result = await ref
        .read(condicaoPagamentoRepositoryHybridProvider)
        .listar();
    if (result is Success<List<CondicaoPagamentoResponse>>) {
      state = state.copyWith(condicoesPagamento: result.value);
    } else if (result is Failure<List<CondicaoPagamentoResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();

    return result;
  }

  // ---------------------------------------------------------------------------
  // Cliente
  // ---------------------------------------------------------------------------
  Future<Result<List<ClienteResponse>>> _listarClientes() async {
    onStartEvent?.call();
    final result = await ref.read(clienteRepositoryHybridProvider).listar();
    if (result is Success<List<ClienteResponse>>) {
      state = state.copyWith(clientes: result.value);
    } else if (result is Failure<List<ClienteResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }

  void selectCliente(ClienteResponse? cliente) {
    state = state.copyWith(selectedCliente: cliente);
  }

  void preencherCliente(ClienteResponse cliente) {
    state = state.copyWith(selectedCliente: cliente);
  }

  // ---------------------------------------------------------------------------
  // Produtos
  // ---------------------------------------------------------------------------
  Future<Result<List<ProdutoResponse>>> _listarProdutos() async {
    onStartEvent?.call();
    final result = await ref.read(produtoRepositoryHybridProvider).listar();
    if (result is Success<List<ProdutoResponse>>) {
      state = state.copyWith(produtos: result.value);
    } else if (result is Failure<List<ProdutoResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }

  void setQuantidade(int produtoId, double quantidade) {
    final updated = Map<int, double>.from(state.carrinhoQuantidades);
    if (quantidade <= 0) {
      updated.remove(produtoId);
    } else {
      updated[produtoId] = quantidade;
    }
    state = state.copyWith(carrinhoQuantidades: updated);
  }

  void preencherCarrinho(List<PedidoItemResponse> itens) {
    final quantidades = <int, double>{
      for (final item in itens) item.produtoId: item.quantidade,
    };
    state = state.copyWith(carrinhoQuantidades: quantidades);
  }

  void limparCarrinho() {
    state = state.copyWith(carrinhoQuantidades: {});
  }

  // ---------------------------------------------------------------------------
  // Pagamento
  // ---------------------------------------------------------------------------
  void setFormaPagamento(String nome) {
    state = state.copyWith(formaPagamentoNome: nome);
  }

  void setCondicaoPagamento(String nome) {
    state = state.copyWith(condicaoPagamentoNome: nome);
  }

  void preencherPagamento(String? formaNome, String? condicaoNome) {
    state = state.copyWith(
      formaPagamentoNome: formaNome,
      condicaoPagamentoNome: condicaoNome,
    );
  }

  void limparPagamento() {
    state = state.copyWith(
      formaPagamentoNome: null,
      condicaoPagamentoNome: null,
    );
  }
}

final pedidoAdicionarViewModelProvider =
    NotifierProvider.autoDispose<
      PedidoAdicionarViewModel,
      PedidoAdicionarUiState
    >(() => PedidoAdicionarViewModel());
