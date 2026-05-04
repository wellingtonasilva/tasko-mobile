import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/usuario/usuario_repository_remote.dart';
import 'package:tasko_mobile/data/repositories/vendedor/vendedor_repository_hybrid.dart';
import 'package:tasko_mobile/domain/usuario/request/atualizar_usuario_request.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/ui/feature/usuario/manter/usuario_manter_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class UsuarioManterViewModel extends Notifier<UsuarioManterUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  UsuarioManterUiState build() {
    return UsuarioManterUiState(
      obterPorIdCommand: Command1<UsuarioResponse, int>(_obterPorId),
      atualizarUsuarioCommand:
          Command1<UsuarioResponse, (int id, AtualizarUsuarioRequest request)>(
            _atualizar,
          ),
      vendedores: [],
      listarVendedoresCommand: Command0<void>(_listarVendedores),
    );
  }

  void setVendedor(VendedorResponse? vendedor) {
    state = state.copyWith(selectedVendedor: vendedor);
  }

  void setIndicadorAtivo(bool value) {
    state = state.copyWith(indicadorAtivo: value);
  }

  Future<Result<UsuarioResponse>> _obterPorId(int id) async {
    onStartEvent?.call();
    final result = await ref
        .read(usuarioRepositoryRemoteProvider)
        .obterPorId(id);

    if (result is Success<UsuarioResponse>) {
      state = state.copyWith(
        usuario: result.value,
        indicadorAtivo: result.value.auditoria.indicadorAtivo,
        isAdmin: result.value.perfis.any(
          (perfil) => perfil.perfilTipo == 'ROLE_ADMIN',
        ),
      );
    } else if (result is Failure<UsuarioResponse>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }

    onFinishEvent?.call();
    return result;
  }

  Future<Result<UsuarioResponse>> _atualizar(
    (int id, AtualizarUsuarioRequest request) parameters,
  ) async {
    onStartEvent?.call();
    final (id, request) = parameters;
    final result = await ref
        .read(usuarioRepositoryRemoteProvider)
        .atualizar(id, request);

    if (result is Success<UsuarioResponse>) {
      state = state.copyWith(
        usuario: result.value,
        indicadorAtivo: result.value.auditoria.indicadorAtivo,
      );
    } else if (result is Failure<UsuarioResponse>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }

    onFinishEvent?.call();
    return result;
  }

  Future<Result<List<VendedorResponse>>> _listarVendedores() async {
    onStartEvent?.call();
    final result = await ref.read(vendedorRepositoryHybridProvider).listar();

    if (result is Success<List<VendedorResponse>>) {
      state = state.copyWith(vendedores: result.value);
    } else if (result is Failure<List<VendedorResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }
}

final usuarioManterViewModelProvider =
    NotifierProvider<UsuarioManterViewModel, UsuarioManterUiState>(
      () => UsuarioManterViewModel(),
    );
