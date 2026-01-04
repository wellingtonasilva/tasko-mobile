import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/vendedor/territorio/vendedor_territorio_repository.dart';
import 'package:tasko_mobile/data/service/vendedor_territorio_service.dart';
import 'package:tasko_mobile/domain/vendedor/request/adicionar_vendedor_territorio_request.dart';
import 'package:tasko_mobile/domain/vendedor/request/atualizar_vendedor_territorio_request.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_territorio_response.dart';
import 'package:tasko_mobile/util/result.dart';

class VendedorTerritorioRepositoryRemote
    implements VendedorTerritorioRepository {
  final VendedorTerritorioService _service;

  VendedorTerritorioRepositoryRemote({
    required VendedorTerritorioService service,
  }) : _service = service;

  @override
  Future<Result<VendedorTerritorioResponse>> adicionar(
    AdicionarVendedorTerritorioRequest request,
  ) async {
    return await _service.adicionar(request);
  }

  @override
  Future<Result<VendedorTerritorioResponse>> atualizar(
    int id,
    AtualizarVendedorTerritorioRequest request,
  ) async {
    return await _service.atualizar(id, request);
  }

  @override
  Future<Result<void>> excluir(int id) async {
    return await _service.excluir(id);
  }

  @override
  Future<Result<List<VendedorTerritorioResponse>>> listar() async {
    return await _service.listar();
  }

  @override
  Future<Result<VendedorTerritorioResponse>> obterPorId(int id) async {
    return await _service.obterPorId(id);
  }
}

final vendedorTerritorioRepositoryRemoteProvider =
    Provider<VendedorTerritorioRepositoryRemote>((ref) {
      final service = ref.watch(vendedorTerritorioServiceProvider);
      return VendedorTerritorioRepositoryRemote(service: service);
    });
