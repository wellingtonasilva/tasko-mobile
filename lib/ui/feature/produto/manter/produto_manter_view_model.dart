import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/produto/produto_repository_hybrid.dart';
import 'package:tasko_mobile/domain/produto/response/produto_grupo_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_subgrupo_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_unidade_medida_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_codigo_barras_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_estoque_localizacao_response.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';
import 'produto_manter_ui_state.dart';

class ProdutoManterViewModel extends Notifier<ProdutoManterUiState> {
  void Function(String, Result result)? showSnackBar;

  @override
  ProdutoManterUiState build() {
    return ProdutoManterUiState(
      obterPorIdCommand: Command1<ProdutoResponse, int>(_obterPorId),
      listarGrupoCommand: Command0<List<ProdutoGrupoResponse>>(_listarGrupos),
      listarSubgrupoCommand: Command0<List<ProdutoSubgrupoResponse>>(
        _listarSubgrupos,
      ),
      listarUnidadeMedidaCommand: Command0<List<ProdutoUnidadeMedidaResponse>>(
        _listarUnidadesMedida,
      ),
      listarCodigoBarrasCommand:
          Command1<List<ProdutoCodigoBarrasResponse>, int>(
            _listarCodigosBarras,
          ),
      listarEstoqueLocalizacaoCommand:
          Command1<List<ProdutoEstoqueLocalizacaoResponse>, int>(
            _listarEstoquesLocalizacao,
          ),
    );
  }

  Future<Result<ProdutoResponse>> _obterPorId(int produtoId) async {
    final result = await ref
        .read(produtoRepositoryHybridProvider)
        .obterPorId(produtoId);
    if (result is Success<ProdutoResponse>) {
      state = state.copyWith(produto: result.value);
    } else if (result is Failure<ProdutoResponse>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    return result;
  }

  Future<Result<List<ProdutoGrupoResponse>>> _listarGrupos() async {
    final result = await ref
        .read(produtoRepositoryHybridProvider)
        .listarGrupos();
    if (result is Success<List<ProdutoGrupoResponse>>) {
      state = state.copyWith(grupos: result.value);
    } else if (result is Failure<List<ProdutoGrupoResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    return result;
  }

  Future<Result<List<ProdutoSubgrupoResponse>>> _listarSubgrupos() async {
    final result = await ref
        .read(produtoRepositoryHybridProvider)
        .listarSubgrupos();
    if (result is Success<List<ProdutoSubgrupoResponse>>) {
      state = state.copyWith(subgrupos: result.value);
    } else if (result is Failure<List<ProdutoSubgrupoResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    return result;
  }

  Future<Result<List<ProdutoUnidadeMedidaResponse>>>
  _listarUnidadesMedida() async {
    final result = await ref
        .read(produtoRepositoryHybridProvider)
        .listarUnidadesMedida();

    if (result is Success<List<ProdutoUnidadeMedidaResponse>>) {
      state = state.copyWith(unidadesMedida: result.value);
    } else if (result is Failure<List<ProdutoUnidadeMedidaResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    return result;
  }

  Future<Result<List<ProdutoCodigoBarrasResponse>>> _listarCodigosBarras(
    int produtoId,
  ) async {
    final result = await ref
        .read(produtoRepositoryHybridProvider)
        .listarCodigosBarras(produtoId: produtoId);

    if (result is Success<List<ProdutoCodigoBarrasResponse>>) {
      state = state.copyWith(codigosBarras: result.value);
    } else if (result is Failure<List<ProdutoCodigoBarrasResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    return result;
  }

  Future<Result<List<ProdutoEstoqueLocalizacaoResponse>>>
  _listarEstoquesLocalizacao(int produtoId) async {
    final result = await ref
        .read(produtoRepositoryHybridProvider)
        .listarEstoques(produtoId: produtoId);

    if (result is Success<List<ProdutoEstoqueLocalizacaoResponse>>) {
      state = state.copyWith(estoquesLocalizacao: result.value);
    } else if (result is Failure<List<ProdutoEstoqueLocalizacaoResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    return result;
  }
}
