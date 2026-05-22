import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/database/forma_pagamento_local_data_source.dart';
import 'package:tasko_mobile/data/repositories/forma_pagamento/forma_pagamento_repository.dart';
import 'package:tasko_mobile/data/repositories/forma_pagamento/forma_pagamento_repository_remote.dart';
import 'package:tasko_mobile/domain/forma_pagamento/request/adicionar_forma_pagamento_request.dart';
import 'package:tasko_mobile/domain/forma_pagamento/request/atualizar_forma_pagamento_request.dart';
import 'package:tasko_mobile/domain/forma_pagamento/response/forma_pagamento_response.dart';
import 'package:tasko_mobile/util/result.dart';

class FormaPagamentoRepositoryHybrid implements FormaPagamentoRepository {
  final FormaPagamentoRepository _remote;
  final FormaPagamentoLocalDataSource _local;

  FormaPagamentoRepositoryHybrid({
    required FormaPagamentoRepository remote,
    required FormaPagamentoLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  @override
  Future<Result<FormaPagamentoResponse>> adicionar(
    AdicionarFormaPagamentoRequest request,
  ) {
    // TODO: implement adicionar
    throw UnimplementedError();
  }

  @override
  Future<Result<FormaPagamentoResponse>> atualizar(
    int id,
    AtualizarFormaPagamentoRequest request,
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
  Future<Result<List<FormaPagamentoResponse>>> listar() async {
    final localResult = await _local.listar();
    if (localResult is Success<List<FormaPagamentoResponse>> &&
        localResult.value.isNotEmpty) {
      return localResult;
    }

    final remoteResult = await _remote.listar();
    if (remoteResult is Success<List<FormaPagamentoResponse>>) {
      await _local.replaceAll(remoteResult.value);
      return remoteResult;
    }

    return remoteResult;
  }

  @override
  Future<Result<FormaPagamentoResponse>> obterPorId(int id) async {
    final localResult = await _local.obterPorId(id);
    if (localResult is Success<FormaPagamentoResponse>) {
      return localResult;
    }

    final remoteResult = await _remote.obterPorId(id);
    if (remoteResult is Success<FormaPagamentoResponse>) {
      await _local.upsert(remoteResult.value);
    }
    return remoteResult;
  }
}

final formaPagamentoRepositoryHybridProvider =
    Provider<FormaPagamentoRepositoryHybrid>((ref) {
      final remote = ref.watch(formaPagamentoRepositoryRemoteProvider);
      final local = ref.watch(formaPagamentoLocalDataSourceProvider);
      return FormaPagamentoRepositoryHybrid(remote: remote, local: local);
    });
