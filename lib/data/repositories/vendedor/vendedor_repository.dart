import 'package:tasko_mobile/domain/vendedor/request/adicionar_vendedor_request.dart';
import 'package:tasko_mobile/domain/vendedor/request/atualizar_vendedor.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/util/result.dart';

abstract class VendedorRepository {
  Future<Result<VendedorResponse>> adicionar(AdicionarVendedorRequest request);
  Future<Result<VendedorResponse>> atualizar(
    int id,
    AtualizarVendedorRequest request,
  );
  Future<Result<List<VendedorResponse>>> listar();
  Future<Result<VendedorResponse>> obterPorId(int id);
  Future<Result<void>> excluir(int id);
}
