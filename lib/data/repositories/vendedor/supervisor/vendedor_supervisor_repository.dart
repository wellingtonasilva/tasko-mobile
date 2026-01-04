import 'package:tasko_mobile/domain/vendedor/request/adicionar_vendedor_supervisor_request.dart';
import 'package:tasko_mobile/domain/vendedor/request/atualizar_vendedor_supervisor_request.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/util/result.dart';

abstract class VendedorSupervisorRepository {
  Future<Result<VendedorSupervisorResponse>> adicionar(
    AdicionarVendedorSupervisorRequest request,
  );
  Future<Result<VendedorSupervisorResponse>> atualizar(
    int id,
    AtualizarVendedorSupervisorRequest request,
  );
  Future<Result<List<VendedorSupervisorResponse>>> listar();
  Future<Result<VendedorSupervisorResponse>> obterPorId(int id);
  Future<Result<void>> excluir(int id);
}
