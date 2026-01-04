import 'package:tasko_mobile/domain/vendedor/request/adicionar_vendedor_territorio_request.dart';
import 'package:tasko_mobile/domain/vendedor/request/atualizar_vendedor_territorio_request.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_territorio_response.dart';
import 'package:tasko_mobile/util/result.dart';

abstract class VendedorTerritorioRepository {
  Future<Result<VendedorTerritorioResponse>> adicionar(
    AdicionarVendedorTerritorioRequest request,
  );
  Future<Result<VendedorTerritorioResponse>> atualizar(
    int id,
    AtualizarVendedorTerritorioRequest request,
  );
  Future<Result<List<VendedorTerritorioResponse>>> listar();
  Future<Result<VendedorTerritorioResponse>> obterPorId(int id);
  Future<Result<void>> excluir(int id);
}
