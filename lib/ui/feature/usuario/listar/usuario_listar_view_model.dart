import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/usuario/usuario_repository_remote.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_response.dart';
import 'package:tasko_mobile/ui/feature/usuario/listar/usuario_listar_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class UsuarioListarViewModel extends Notifier<UsuarioListarUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  UsuarioListarUiState build() {
    return UsuarioListarUiState(
      usuarios: [],
      listarUsuariosCommand: Command0<List<UsuarioResponse>>(_listarUsuarios),
      excluirUsuarioCommand: Command1<void, int>(_excluirUsuario),
    );
  }

  Future<Result<List<UsuarioResponse>>> _listarUsuarios() async {
    onStartEvent?.call();
    final repository = ref.read(usuarioRepositoryRemoteProvider);
    final result = await repository.listar();

    if (result is Success<List<UsuarioResponse>>) {
      state = state.copyWith(usuarios: result.value);
    } else if (result is Failure) {
      state = state.copyWith(usuarios: []);

      showSnackBar?.call(
        (result as Failure).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }

    onFinishEvent?.call();
    return result;
  }

  Future<Result<void>> _excluirUsuario(int id) async {
    onStartEvent?.call();

    final repository = ref.read(usuarioRepositoryRemoteProvider);
    final result = await repository.excluir(id);
    if (result is Success<void>) {
      await _listarUsuarios();
      showSnackBar?.call(('Usuário excluído com sucesso!'), result);
    } else if (result is Failure) {
      showSnackBar?.call(
        result.errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }

    onFinishEvent?.call();
    return result;
  }
}

final usuarioListarViewModelProvider =
    NotifierProvider<UsuarioListarViewModel, UsuarioListarUiState>(
      () => UsuarioListarViewModel(),
    );
