import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/common/domain/dropdown_loading_state.dart';
import 'package:tasko_mobile/data/repositories/cliente/cliente_repository_hybrid.dart';
import 'package:tasko_mobile/data/repositories/vendedor/vendedor_repository_remote.dart';
import 'package:tasko_mobile/domain/cliente/request/adicionar_cliente_request.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/ui/feature/cliente/adicionar/cliente_adicionar_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class ClienteAdicionarViewModel extends Notifier<ClienteAdicionarUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onAdicionarSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  ClienteAdicionarUiState build() {
    return ClienteAdicionarUiState(
      clienteDraft: ClienteResponse(id: -1, razaoSocial: ''),
      adicionarCommand: Command1<ClienteResponse, AdicionarClienteRequest>(
        _adicionar,
      ),
      listarVendedorCommand: Command0<void>(_listarVendedor)..execute(),
    );
  }

  void enviar() {
    final cliente = state.clienteDraft;
    if (cliente == null) return;

    final request = AdicionarClienteRequest(
      vendedorId: state.selectedVendedor?.id,
      codigoCliente: cliente.codigoCliente,
      razaoSocial: cliente.razaoSocial,
      nomeFantasia: cliente.nomeFantasia,
      cnpjCpf: cliente.cnpjCpf,
      cep: cliente.cep,
      logradouro: cliente.logradouro,
      logradouroNumero: cliente.logradouroNumero,
      complemento: cliente.complemento,
      bairro: cliente.bairro,
      cidade: cliente.cidade,
      estado: cliente.estado,
      numeroTelefone: cliente.numeroTelefone,
      numeroTelefoneSecundario: cliente.numeroTelefoneSecundario,
      email: cliente.email,
      observacao: cliente.observacao,
      limiteCredito: cliente.limiteCredito,
    );

    state.adicionarCommand.execute(request);
  }

  void salvarDadosBasicos({
    String? codigoCliente,
    String? razaoSocial,
    String? nomeFantasia,
    String? cnpjCpf,
    double? limiteCredito,
  }) {
    final draft = state.clienteDraft;
    if (draft == null) return;

    state = state.copyWith(
      clienteDraft: draft.copyWith(
        codigoCliente: codigoCliente,
        razaoSocial: razaoSocial,
        nomeFantasia: nomeFantasia,
        cnpjCpf: cnpjCpf,
        limiteCredito: limiteCredito,
        vendedorId: state.selectedVendedor?.id,
      ),
    );
  }

  void salvarDadosContatoEndereco({
    String? cep,
    String? logradouro,
    String? logradouroNumero,
    String? complemento,
    String? bairro,
    String? cidade,
    String? estado,
    String? numeroTelefone,
    String? numeroTelefoneSecundario,
    String? email,
    String? observacao,
  }) {
    final draft = state.clienteDraft;
    if (draft == null) return;

    state = state.copyWith(
      clienteDraft: draft.copyWith(
        cep: cep,
        logradouro: logradouro,
        logradouroNumero: logradouroNumero,
        complemento: complemento,
        bairro: bairro,
        cidade: cidade,
        estado: estado,
        numeroTelefone: numeroTelefone,
        numeroTelefoneSecundario: numeroTelefoneSecundario,
        email: email,
        observacao: observacao,
      ),
    );
  }

  Future<Result<ClienteResponse>> _adicionar(
    AdicionarClienteRequest request,
  ) async {
    final result = await ref
        .read(clienteRepositoryHybridProvider)
        .adicionar(request);

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

  //------------------- Vendedor ------------------
  Future<Result<List<VendedorResponse>>> _listarVendedor() async {
    onStartEvent?.call();
    final result = await ref.read(vendedorRepositoryRemoteProvider).listar();
    if (result is Success<List<VendedorResponse>>) {
      state = state.copyWith(vendedores: result.value);
    } else if (result is Failure<List<VendedorResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();

    return result;
  }

  VendedorResponse? get computedSelectedVendedor {
    final vendedorId = state.clienteDraft?.vendedorId;
    if (vendedorId == null || state.vendedores == null) return null;

    final found = state.vendedores!.firstWhere(
      (v) => v.id == vendedorId,
      orElse: () => VendedorResponse(id: -1),
    );
    return found.id == -1 ? null : found;
  }

  DropdownLoadingState get vendedorDropdownState {
    if (state.listarVendedorCommand.running) {
      return DropdownLoadingState.loading;
    }
    if (state.listarVendedorCommand.completed) {
      return DropdownLoadingState.ready;
    }
    return DropdownLoadingState.error;
  }

  void selectVendedor(VendedorResponse? vendedor) {
    state = state.copyWith(selectedVendedor: vendedor);
  }
}

final clienteAdicionarViewModelProvider =
    NotifierProvider.autoDispose<
      ClienteAdicionarViewModel,
      ClienteAdicionarUiState
    >(ClienteAdicionarViewModel.new);
