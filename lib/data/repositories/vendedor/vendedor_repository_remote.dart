import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/vendedor/vendedor_repository.dart';
import 'package:tasko_mobile/data/service/vendedor_service.dart';
import 'package:tasko_mobile/domain/vendedor/request/adicionar_vendedor_request.dart';
import 'package:tasko_mobile/domain/vendedor/request/atualizar_vendedor.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/util/result.dart';

class VendedorRepositoryRemote implements VendedorRepository {
  final VendedorService _service;

  VendedorRepositoryRemote({required VendedorService service})
    : _service = service;

  @override
  Future<Result<VendedorResponse>> adicionar(
    AdicionarVendedorRequest request,
  ) async {
    return await _service.adicionar(request);
  }

  @override
  Future<Result<VendedorResponse>> atualizar(
    int id,
    AtualizarVendedorRequest request,
  ) async {
    return await _service.atualizar(id, request);
  }

  @override
  Future<Result<void>> excluir(int id) async {
    return await _service.excluir(id);
  }

  @override
  Future<Result<List<VendedorResponse>>> listar() async {
    return await _service.listar();
  }

  @override
  Future<Result<VendedorResponse>> obterPorId(int id) async {
    return await _service.obterPorId(id);
  }
}

final vendedorRepositoryRemoteProvider = Provider<VendedorRepositoryRemote>((
  ref,
) {
  final service = ref.watch(vendedorServiceProvider);
  return VendedorRepositoryRemote(service: service);
});
