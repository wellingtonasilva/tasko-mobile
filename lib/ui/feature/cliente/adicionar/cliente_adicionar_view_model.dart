import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/common/core/vendedor_sessao_provider.dart';
import 'package:tasko_mobile/data/repositories/cliente/cliente_repository_hybrid.dart';
import 'package:tasko_mobile/domain/cliente/request/adicionar_cliente_request.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/ui/feature/cliente/adicionar/cliente_adicionar_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class ClienteAdicionarViewModel extends Notifier<ClienteAdicionarUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onAdicionarSucesso;

  @override
  ClienteAdicionarUiState build() {
    return ClienteAdicionarUiState(
      adicionarCommand: Command1<ClienteResponse, AdicionarClienteRequest>(
        _adicionar,
      ),
    );
  }

  Future<Result<ClienteResponse>> _adicionar(
    AdicionarClienteRequest request,
  ) async {
    final vendedorId = ref.read(vendedorSelecionadoIdProvider);
    final requestWithVendedor = AdicionarClienteRequest(
      vendedorId: vendedorId,
      codigoCliente: request.codigoCliente,
      razaoSocial: request.razaoSocial,
      nomeFantasia: request.nomeFantasia,
      cnpjCpf: request.cnpjCpf,
      cidade: request.cidade,
      estado: request.estado,
      limiteCredito: request.limiteCredito,
      bloqueado: request.bloqueado,
      motivoBloqueio: request.motivoBloqueio,
      bairro: request.bairro,
      cep: request.cep,
      categoria: request.categoria,
      complemento: request.complemento,
      inscricaoEstadual: request.inscricaoEstadual,
      latitude: request.latitude,
      logradouro: request.logradouro,
      longitude: request.longitude,
      prazoPagamento: request.prazoPagamento,
      segmento: request.segmento,
      tipo: request.tipo,
    );

    final result = await ref
        .read(clienteRepositoryHybridProvider)
        .adicionar(requestWithVendedor);

    if (result is Success<ClienteResponse>) {
      showSnackBar?.call('Cliente adicionado com sucesso!', result);
      onAdicionarSucesso?.call();
    } else if (result is Failure<ClienteResponse>) {
      showSnackBar?.call(
        result.errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    return result;
  }
}

final clienteAdicionarViewModelProvider =
    NotifierProvider<ClienteAdicionarViewModel, ClienteAdicionarUiState>(
      ClienteAdicionarViewModel.new,
    );
