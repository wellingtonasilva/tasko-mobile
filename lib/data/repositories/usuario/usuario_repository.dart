import 'package:tasko_mobile/domain/usuario/request/adicionar_usuario_request.dart';
import 'package:tasko_mobile/domain/usuario/request/atualizar_usuario_request.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_response.dart';
import 'package:tasko_mobile/util/result.dart';

abstract class UsuarioRepository {
  Future<Result<List<UsuarioResponse>>> listar();
  Future<Result<UsuarioResponse>> obterPorId(int id);
  Future<Result<void>> excluir(int id);
  Future<Result<UsuarioResponse>> adicionar(AdicionarUsuarioRequest request);
  Future<Result<UsuarioResponse>> atualizar(
    int id,
    AtualizarUsuarioRequest request,
  );
}
