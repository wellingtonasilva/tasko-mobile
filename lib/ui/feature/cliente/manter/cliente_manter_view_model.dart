import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/cliente/cliente_repository_hybrid.dart';
import 'package:tasko_mobile/domain/cliente/request/atualizar_cliente_request.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/ui/feature/cliente/manter/cliente_manter_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class ClienteManterViewModel extends Notifier<ClienteManterUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onManterSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  ClienteManterUiState build() {
    return ClienteManterUiState(
      obterPorIdCommand: Command1<ClienteResponse, (int id,)>(_obterPorId),
      atualizarCommand:
          Command1<ClienteResponse, (int id, AtualizarClienteRequest request)>(
            _atualizar,
          ),
    );
  }

  void enviar() {
    final cliente = state.clienteDraft;
    if (cliente == null) return;

    final request = AtualizarClienteRequest(
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
      id: cliente.id,
      limiteCredito: cliente.limiteCredito,
    );

    state.atualizarCommand.execute((cliente.id, request));
  }

  void salvarDadosBasicos({
    String? codigoCliente,
    String? razaoSocial,
    String? nomeFantasia,
    String? cnpjCpf,
    double? limiteCredito,
  }) {
    final draft = state.clienteDraft ?? state.cliente;
    if (draft == null) return;

    state = state.copyWith(
      clienteDraft: draft.copyWith(
        codigoCliente: codigoCliente,
        razaoSocial: razaoSocial,
        nomeFantasia: nomeFantasia,
        cnpjCpf: cnpjCpf,
        limiteCredito: limiteCredito,
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
    final draft = state.clienteDraft ?? state.cliente;
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

  Future<Result<ClienteResponse>> _obterPorId((int id,) parameters) async {
    final (id,) = parameters;
    onStartEvent?.call();
    final result = await ref
        .read(clienteRepositoryHybridProvider)
        .obterPorId(id);

    if (result is Success<ClienteResponse>) {
      state = state.copyWith(cliente: result.value, clienteDraft: result.value);
    } else if (result is Failure<ClienteResponse>) {
      showSnackBar?.call(
        result.errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();

    return result;
  }

  Future<Result<ClienteResponse>> _atualizar(
    (int id, AtualizarClienteRequest request) parameters,
  ) async {
    onStartEvent?.call();
    final (id, request) = parameters;
    final result = await ref
        .read(clienteRepositoryHybridProvider)
        .atualizar(id, request);

    if (result is Success<ClienteResponse>) {
      state = state.copyWith(cliente: result.value, clienteDraft: result.value);
      showSnackBar?.call('Cliente atualizado com sucesso!', result);
      onManterSucesso?.call();
    } else if (result is Failure<ClienteResponse>) {
      showSnackBar?.call(
        result.errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();

    return result;
  }
}

final clienteManterViewModelProvider =
    NotifierProvider<ClienteManterViewModel, ClienteManterUiState>(
      ClienteManterViewModel.new,
    );
