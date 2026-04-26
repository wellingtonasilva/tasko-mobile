import 'package:tasko_mobile/data/repositories/empresa/empresa_repository.dart';
import 'package:tasko_mobile/data/service/empresa_service.dart';
import 'package:tasko_mobile/domain/empresa/request/adicionar_empresa_request.dart';
import 'package:tasko_mobile/domain/empresa/request/atualizar_empresa_request.dart';
import 'package:tasko_mobile/domain/empresa/request/criar_empresa_request.dart';
import 'package:tasko_mobile/domain/empresa/response/empresa_response.dart';
import 'package:tasko_mobile/util/result.dart';

class EmpresaRepositoryRemote implements EmpresaRepository {
  final EmpresaService _empresaService;

  EmpresaRepositoryRemote({required EmpresaService empresaService})
    : _empresaService = empresaService;

  @override
  Future<Result<EmpresaResponse>> adicionar(AdicionarEmpresaRequest request) {
    return _empresaService.adicionar(request);
  }

  @override
  Future<Result<EmpresaResponse>> atualizar(
    int id,
    AtualizarEmpresaRequest request,
  ) {
    return _empresaService.atualizar(id, request);
  }

  @override
  Future<Result<EmpresaResponse>> criarEmpresa(CriarEmpresaRequest request) {
    return _empresaService.criarEmpresa(request);
  }

  @override
  Future<Result<void>> excluir(int id) {
    return _empresaService.excluir(id);
  }

  @override
  Future<Result<List<EmpresaResponse>>> listar() {
    return _empresaService.listar();
  }

  @override
  Future<Result<EmpresaResponse>> obterPorId(int id) {
    return _empresaService.obterPorId(id);
  }
}
