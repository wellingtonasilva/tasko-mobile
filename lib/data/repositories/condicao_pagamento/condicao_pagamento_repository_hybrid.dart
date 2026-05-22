import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/database/condicao_pagamento_Local_data_source.dart';
import 'package:tasko_mobile/data/repositories/condicao_pagamento/condicao_pagamento_repository.dart';
import 'package:tasko_mobile/data/repositories/condicao_pagamento/condicao_pagamento_repository_remote.dart';
import 'package:tasko_mobile/domain/condicao_pagamento/request/adicionar_condicao_pagamento_request.dart';
import 'package:tasko_mobile/domain/condicao_pagamento/request/atualizar_condicao_pagamento_request.dart';
import 'package:tasko_mobile/domain/condicao_pagamento/response/condicao_pagamento_response.dart';
import 'package:tasko_mobile/util/result.dart';

class CondicaoPagamentoRepositoryHybrid implements CondicaoPagamentoRepository {
  final CondicaoPagamentoRepository _remote;
  final CondicaoPagamentoLocalDataSource _local;

  CondicaoPagamentoRepositoryHybrid({
    required CondicaoPagamentoRepository remote,
    required CondicaoPagamentoLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  @override
  Future<Result<CondicaoPagamentoResponse>> adicionar(
    AdicionarCondicaoPagamentoRequest request,
  ) {
    // TODO: implement adicionar
    throw UnimplementedError();
  }

  @override
  Future<Result<CondicaoPagamentoResponse>> atualizar(
    int id,
    AtualizarCondicaoPagamentoRequest request,
  ) {
    // TODO: implement atualizar
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> excluir(int id) {
    // TODO: implement excluir
    throw UnimplementedError();
  }

  @override
  Future<Result<List<CondicaoPagamentoResponse>>> listar() async {
    final localResult = await _local.listar();
    if (localResult is Success<List<CondicaoPagamentoResponse>> &&
        localResult.value.isNotEmpty) {
      return localResult;
    }

    final remoteResult = await _remote.listar();
    if (remoteResult is Success<List<CondicaoPagamentoResponse>>) {
      await _local.replaceAll(remoteResult.value);
      return remoteResult;
    }

    return remoteResult;
  }

  @override
  Future<Result<CondicaoPagamentoResponse>> obterPorId(int id) async {
    final localResult = await _local.obterPorId(id);
    if (localResult is Success<CondicaoPagamentoResponse>) {
      return localResult;
    }

    final remoteResult = await _remote.obterPorId(id);
    if (remoteResult is Success<CondicaoPagamentoResponse>) {
      await _local.upsert(remoteResult.value);
    }
    return remoteResult;
  }

  @override
  Future<Result<List<CondicaoPagamentoResponse>>> listarByFormaPagamento(
    int formaPagamentoId,
  ) async {
    final localResult = await _local.listar(formaPagamentoId: formaPagamentoId);
    if (localResult is Success<List<CondicaoPagamentoResponse>> &&
        localResult.value.isNotEmpty) {
      return localResult;
    }

    final remoteResult = await _remote.listar();
    if (remoteResult is Success<List<CondicaoPagamentoResponse>>) {
      await _local.replaceAll(remoteResult.value);
      return remoteResult;
    }

    return remoteResult;
  }
}

final condicaoPagamentoRepositoryHybridProvider =
    Provider<CondicaoPagamentoRepositoryHybrid>((ref) {
      final remote = ref.watch(condicaoPagamentoRepositoryRemoteProvider);
      final local = ref.watch(condicaoPagamentoLocalDataSourceProvider);
      return CondicaoPagamentoRepositoryHybrid(remote: remote, local: local);
    });
