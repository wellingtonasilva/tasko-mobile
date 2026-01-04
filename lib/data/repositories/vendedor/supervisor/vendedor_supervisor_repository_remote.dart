import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/vendedor/supervisor/vendedor_supervisor_repository.dart';
import 'package:tasko_mobile/data/service/vendedor_supervisor_service.dart';
import 'package:tasko_mobile/domain/vendedor/request/adicionar_vendedor_supervisor_request.dart';
import 'package:tasko_mobile/domain/vendedor/request/atualizar_vendedor_supervisor_request.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/util/result.dart';

class VendedorSupervisorRepositoryRemote
    implements VendedorSupervisorRepository {
  final VendedorSupervisorService _service;

  VendedorSupervisorRepositoryRemote({
    required VendedorSupervisorService service,
  }) : _service = service;

  @override
  Future<Result<VendedorSupervisorResponse>> adicionar(
    AdicionarVendedorSupervisorRequest request,
  ) async {
    return await _service.adicionar(request);
  }

  @override
  Future<Result<VendedorSupervisorResponse>> atualizar(
    int id,
    AtualizarVendedorSupervisorRequest request,
  ) async {
    return await _service.atualizar(id, request);
  }

  @override
  Future<Result<void>> excluir(int id) async {
    return await _service.excluir(id);
  }

  @override
  Future<Result<List<VendedorSupervisorResponse>>> listar() async {
    return await _service.listar();
  }

  @override
  Future<Result<VendedorSupervisorResponse>> obterPorId(int id) async {
    return await _service.obterPorId(id);
  }
}

final vendedorSupervisorRepositoryRemoteProvider =
    Provider<VendedorSupervisorRepositoryRemote>((ref) {
      final service = ref.watch(vendedorSupervisorServiceProvider);
      return VendedorSupervisorRepositoryRemote(service: service);
    });
