import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/util/command.dart';

class ClienteManterUiState {
  ClienteResponse? cliente;
  ClienteResponse? clienteDraft;
  final Command1 obterPorIdCommand;
  final Command1 atualizarCommand;

  // Vendedor
  final Command0<void> listarVendedorCommand;
  List<VendedorResponse>? vendedores;
  VendedorResponse? selectedVendedor;

  ClienteManterUiState({
    this.cliente,
    this.clienteDraft,
    required this.obterPorIdCommand,
    required this.atualizarCommand,
    required this.listarVendedorCommand,
    this.vendedores,
    this.selectedVendedor,
  });

  ClienteManterUiState copyWith({
    ClienteResponse? cliente,
    ClienteResponse? clienteDraft,
    Command1? obterPorIdCommand,
    Command1? atualizarCommand,
    Command0<void>? listarVendedorCommand,
    List<VendedorResponse>? vendedores,
    VendedorResponse? selectedVendedor,
  }) {
    return ClienteManterUiState(
      cliente: cliente ?? this.cliente,
      clienteDraft: clienteDraft ?? this.clienteDraft,
      obterPorIdCommand: obterPorIdCommand ?? this.obterPorIdCommand,
      atualizarCommand: atualizarCommand ?? this.atualizarCommand,
      listarVendedorCommand:
          listarVendedorCommand ?? this.listarVendedorCommand,
      vendedores: vendedores ?? this.vendedores,
      selectedVendedor: selectedVendedor ?? this.selectedVendedor,
    );
  }
}
