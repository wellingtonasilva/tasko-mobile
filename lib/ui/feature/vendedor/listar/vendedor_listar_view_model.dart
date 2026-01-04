import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/vendedor/vendedor_repository_remote.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/ui/feature/vendedor/listar/vendedor_listar_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class VendedorListarViewModel extends Notifier<VendedorListarUiState> {
  void Function(String, Result result)? showSnackBar;

  @override
  VendedorListarUiState build() {
    return VendedorListarUiState(
      vendedores: [],
      listarVendedoresCommand: Command0<void>(_listarVendedores)..execute(),
      excluirVendedorCommand: Command1<void, int>(_excluirVendedor),
    );
  }

  Future<Result<void>> _listarVendedores() async {
    final repository = ref.read(vendedorRepositoryRemoteProvider);
    final result = await repository.listar();

    if (result is Success<List<VendedorResponse>>) {
      state = state.copyWith(vendedores: result.value);
    } else if (result is Failure) {
      state = state.copyWith(
        vendedores: [],
        listarVendedoresCommand: state.listarVendedoresCommand,
      );

      showSnackBar?.call(
        (result as Failure).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    return result;
  }

  Future<Result<void>> _excluirVendedor(int id) async {
    final repository = ref.read(vendedorRepositoryRemoteProvider);
    final result = await repository.excluir(id);
    if (result is Success<void>) {
      await _listarVendedores();
      showSnackBar?.call(('Vendedor excluído com sucesso!'), result);
    } else if (result is Failure) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    return result;
  }
}

final vendedorListarViewModelProvider =
    NotifierProvider<VendedorListarViewModel, VendedorListarUiState>(
      () => VendedorListarViewModel(),
    );
