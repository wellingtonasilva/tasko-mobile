import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/usuario/usuario_repository.dart';
import 'package:tasko_mobile/data/service/usuario_service.dart';
import 'package:tasko_mobile/domain/usuario/request/adicionar_usuario_request.dart';
import 'package:tasko_mobile/domain/usuario/request/atualizar_usuario_request.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_response.dart';
import 'package:tasko_mobile/util/result.dart';

class UsuarioRepositoryRemote implements UsuarioRepository {
  final UsuarioService _service;

  UsuarioRepositoryRemote({required UsuarioService service})
    : _service = service;

  @override
  Future<Result<UsuarioResponse>> adicionar(AdicionarUsuarioRequest request) {
    return _service.adicionar(request);
  }

  @override
  Future<Result<UsuarioResponse>> atualizar(
    int id,
    AtualizarUsuarioRequest request,
  ) {
    return _service.atualizar(id, request);
  }

  @override
  Future<Result<void>> excluir(int id) {
    return _service.excluir(id);
  }

  @override
  Future<Result<List<UsuarioResponse>>> listar() {
    return _service.listar();
  }

  @override
  Future<Result<UsuarioResponse>> obterPorId(int id) {
    return _service.obterPorId(id);
  }
}

final usuarioRepositoryRemoteProvider = Provider<UsuarioRepositoryRemote>((
  ref,
) {
  final usuarioService = ref.watch(usuarioServiceProvider);
  return UsuarioRepositoryRemote(service: usuarioService);
});
