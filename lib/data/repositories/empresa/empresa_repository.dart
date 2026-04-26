import 'package:tasko_mobile/domain/empresa/request/adicionar_empresa_request.dart';
import 'package:tasko_mobile/domain/empresa/request/atualizar_empresa_request.dart';
import 'package:tasko_mobile/domain/empresa/request/criar_empresa_request.dart';
import 'package:tasko_mobile/domain/empresa/response/empresa_response.dart';
import 'package:tasko_mobile/util/result.dart';

abstract class EmpresaRepository {
  Future<Result<List<EmpresaResponse>>> listar();
  Future<Result<EmpresaResponse>> obterPorId(int id);
  Future<Result<void>> excluir(int id);
  Future<Result<EmpresaResponse>> adicionar(AdicionarEmpresaRequest request);
  Future<Result<EmpresaResponse>> criarEmpresa(CriarEmpresaRequest request);
  Future<Result<EmpresaResponse>> atualizar(
    int id,
    AtualizarEmpresaRequest request,
  );
}
