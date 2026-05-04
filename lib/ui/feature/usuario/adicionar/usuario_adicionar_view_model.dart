import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/usuario/usuario_repository_remote.dart';
import 'package:tasko_mobile/data/repositories/vendedor/vendedor_repository_hybrid.dart';
import 'package:tasko_mobile/domain/usuario/request/adicionar_usuario_request.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/ui/feature/usuario/adicionar/usuario_adicionar_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class UsuarioAdicionarViewModel extends Notifier<UsuarioAdicionarUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onAdicionarSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  UsuarioAdicionarUiState build() {
    return UsuarioAdicionarUiState(
      adicionarUsuarioCommand:
          Command1<UsuarioResponse, AdicionarUsuarioRequest>(_adicionar),
      vendedores: [],
      listarVendedoresCommand: Command0<void>(_listarVendedores),
    );
  }

  Future<Result<UsuarioResponse>> _adicionar(
    AdicionarUsuarioRequest request,
  ) async {
    onStartEvent?.call();
    final result = await ref
        .read(usuarioRepositoryRemoteProvider)
        .adicionar(request);

    if (result is Success<UsuarioResponse>) {
      state = state.copyWith(
        indicadorAtivo: result.value.auditoria.indicadorAtivo,
      );
      onAdicionarSucesso?.call();
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

final usuarioAdicionarViewModelProvider =
    NotifierProvider<UsuarioAdicionarViewModel, UsuarioAdicionarUiState>(
      () => UsuarioAdicionarViewModel(),
    );
