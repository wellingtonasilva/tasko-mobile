import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/vendedor/territorio/vendedor_territorio_repository_remote.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_territorio_response.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';
import 'territorio_listar_ui_state.dart';

class TerritorioListarViewModel extends Notifier<TerritorioListarUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onExcluirSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  TerritorioListarUiState build() {
    return TerritorioListarUiState(
      territorios: [],
      listarTerritoriosCommand: Command0(_listarTerritorios)..execute(),
      excluirTerritorioCommand: Command1<void, int>(_excluirTerritorio),
    );
  }

  Future<Result<void>> _listarTerritorios() async {
    onStartEvent?.call();
    final result = await ref
        .read(vendedorTerritorioRepositoryRemoteProvider)
        .listar();
    if (!ref.mounted) return result;

    if (result is Success<List<VendedorTerritorioResponse>>) {
      state = state.copyWith(territorios: result.value);
    } else if (result is Failure<List<VendedorTerritorioResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    if (!ref.mounted) return result;
    onFinishEvent?.call();

    return result;
  }

  Future<Result<void>> _excluirTerritorio(int id) async {
    onStartEvent?.call();
    final repository = ref.read(vendedorTerritorioRepositoryRemoteProvider);
    final result = await repository.excluir(id);
    if (result is Success<void>) {
      await _listarTerritorios();
      showSnackBar?.call(('Território excluído com sucesso!'), result);
      onExcluirSucesso?.call();
    } else if (result is Failure) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }
}

final territorioListarViewModelProvider =
    NotifierProvider<TerritorioListarViewModel, TerritorioListarUiState>(
      () => TerritorioListarViewModel(),
    );
