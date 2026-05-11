import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/util/command.dart';

class ClienteAdicionarUiState {
  ClienteResponse? clienteDraft;
  final Command1<ClienteResponse, dynamic> adicionarCommand;

  // Vendedor
  final Command0<void> listarVendedorCommand;
  List<VendedorResponse>? vendedores;
  VendedorResponse? selectedVendedor;

  ClienteAdicionarUiState({
    required this.adicionarCommand,
    required this.listarVendedorCommand,
    this.clienteDraft,
    this.vendedores,
    this.selectedVendedor,
  });

  ClienteAdicionarUiState copyWith({
    ClienteResponse? clienteDraft,
    Command1<ClienteResponse, dynamic>? adicionarCommand,
    Command0<void>? listarVendedorCommand,
    List<VendedorResponse>? vendedores,
    VendedorResponse? selectedVendedor,
  }) {
    return ClienteAdicionarUiState(
      clienteDraft: clienteDraft ?? this.clienteDraft,
      adicionarCommand: adicionarCommand ?? this.adicionarCommand,
      listarVendedorCommand:
          listarVendedorCommand ?? this.listarVendedorCommand,
      vendedores: vendedores ?? this.vendedores,
      selectedVendedor: selectedVendedor ?? this.selectedVendedor,
    );
  }
}
