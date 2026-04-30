import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/database/produto_local_data_source.dart';
import 'package:tasko_mobile/data/repositories/produto/produto_repository.dart';
import 'package:tasko_mobile/data/repositories/produto/produto_repository_remote.dart';
import 'package:tasko_mobile/domain/produto/response/produto_codigo_barras_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_estoque_localizacao_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_grupo_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_preco_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_unidade_medida_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_subgrupo_response.dart';
import 'package:tasko_mobile/util/result.dart';

class ProdutoRepositoryHybrid implements ProdutoRepository {
  ProdutoRepositoryHybrid({
    required ProdutoRepositoryRemote remote,
    required ProdutoLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  final ProdutoRepositoryRemote _remote;
  final ProdutoLocalDataSource _local;

  @override
  Future<Result<List<ProdutoResponse>>> listar({
    String? termoBusca,
    int? grupoId,
    int? subgrupoId,
  }) async {
    final localResult = await _local.listar(
      termoBusca: termoBusca,
      grupoId: grupoId,
      subgrupoId: subgrupoId,
    );

    if (localResult is Success<List<ProdutoResponse>> &&
        localResult.value.isNotEmpty) {
      return localResult;
    }

    final remoteResult = await _remote.listar(
      termoBusca: termoBusca,
      grupoId: grupoId,
      subgrupoId: subgrupoId,
    );

    if (remoteResult is Success<List<ProdutoResponse>>) {
      await _local.replaceAll(remoteResult.value);
      return remoteResult;
    }

    return remoteResult;
  }

  @override
  Future<Result<ProdutoResponse>> obterPorId(int id) async {
    final localResult = await _local.obterPorId(id);
    if (localResult is Success<ProdutoResponse>) {
      return localResult;
    }

    final remoteResult = await _remote.obterPorId(id);
    if (remoteResult is Success<ProdutoResponse>) {
      await _local.upsert(remoteResult.value);
      return remoteResult;
    }

    return remoteResult;
  }

  @override
  Future<Result<List<ProdutoPrecoResponse>>> listarPrecos({int? produtoId}) {
    return _remote.listarPrecos(produtoId: produtoId);
  }

  @override
  Future<Result<List<ProdutoEstoqueLocalizacaoResponse>>> listarEstoques({
    int? produtoId,
  }) {
    return _remote.listarEstoques(produtoId: produtoId);
  }

  @override
  Future<Result<List<ProdutoCodigoBarrasResponse>>> listarCodigosBarras({
    int? produtoId,
  }) {
    return _remote.listarCodigosBarras(produtoId: produtoId);
  }

  @override
  Future<Result<List<ProdutoGrupoResponse>>> listarGrupos() {
    return _remote.listarGrupos();
  }

  @override
  Future<Result<List<ProdutoUnidadeMedidaResponse>>> listarUnidadesMedida() {
    return _remote.listarUnidadesMedida();
  }

  Future<Result<List<ProdutoResponse>>> sincronizarListaComServidor({
    String? termoBusca,
    int? grupoId,
    int? subgrupoId,
  }) async {
    final remoteResult = await _remote.listar(
      termoBusca: termoBusca,
      grupoId: grupoId,
      subgrupoId: subgrupoId,
    );

    if (remoteResult is Failure<List<ProdutoResponse>>) {
      return remoteResult;
    }

    final produtos = (remoteResult as Success<List<ProdutoResponse>>).value;
    final persistedResult = await _local.replaceAll(produtos);
    if (persistedResult is Failure<void>) {
      return Result.failure(persistedResult.errors);
    }

    return _local.listar(
      termoBusca: termoBusca,
      grupoId: grupoId,
      subgrupoId: subgrupoId,
    );
  }

  @override
  Future<Result<List<ProdutoSubgrupoResponse>>> listarSubgrupos() {
    return _remote.listarSubgrupos();
  }
}

final produtoRepositoryHybridProvider = Provider<ProdutoRepositoryHybrid>((
  ref,
) {
  final remote = ref.watch(produtoRepositoryRemoteProvider);
  final local = ref.watch(produtoLocalDataSourceProvider);

  return ProdutoRepositoryHybrid(remote: remote, local: local);
});
