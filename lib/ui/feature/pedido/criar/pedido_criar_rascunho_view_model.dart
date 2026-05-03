import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/pedido/pedido_repository_hybrid.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_request.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_response.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/pedido_criar_rascunho_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class PedidoCriarRascunhoViewModel
    extends Notifier<PedidoCriarRascunhoUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  PedidoCriarRascunhoUiState build() {
    return PedidoCriarRascunhoUiState(
      criarRascunhoCommand: Command1<PedidoResponse, AdicionarPedidoRequest>(
        _criarRascunho,
      ),
      atualizarRascunhoCommand:
          Command1<PedidoResponse, AtualizarPedidoRascunhoArgs>(
            _atualizarRascunho,
          ),
    );
  }

  Future<Result<PedidoResponse>> _criarRascunho(
    AdicionarPedidoRequest request,
  ) async {
    onStartEvent?.call();

    final result = await ref
        .read(pedidoRepositoryHybridProvider)
        .criarRascunho(request);

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

  void limpar() {
    state = state.copyWith(clearPedido: true);
  }
}

final pedidoCriarRascunhoViewModelProvider =
    NotifierProvider<PedidoCriarRascunhoViewModel, PedidoCriarRascunhoUiState>(
      () => PedidoCriarRascunhoViewModel(),
    );
