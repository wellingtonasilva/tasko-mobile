import 'package:tasko_mobile/domain/usuario/request/adicionar_usuario_request.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/util/command.dart';

class UsuarioAdicionarUiState {
  final Command1<UsuarioResponse, AdicionarUsuarioRequest>
  adicionarUsuarioCommand;

  final List<VendedorResponse> vendedores;
  final Command0 listarVendedoresCommand;
  VendedorResponse? selectedVendedor;

  UsuarioAdicionarUiState({
    required this.adicionarUsuarioCommand,
    required this.vendedores,
    required this.listarVendedoresCommand,
    this.selectedVendedor,
  });

  UsuarioAdicionarUiState copyWith({
    Command1<UsuarioResponse, AdicionarUsuarioRequest>? adicionarUsuarioCommand,
    List<VendedorResponse>? vendedores,
    Command0? listarVendedoresCommand,
    VendedorResponse? selectedVendedor,
    bool? indicadorAtivo,
    bool? isAdmin,
  }) {
    return UsuarioAdicionarUiState(
      adicionarUsuarioCommand:
          adicionarUsuarioCommand ?? this.adicionarUsuarioCommand,
      vendedores: vendedores ?? this.vendedores,
      listarVendedoresCommand:
          listarVendedoresCommand ?? this.listarVendedoresCommand,
      selectedVendedor: selectedVendedor ?? this.selectedVendedor,
    );
  }
}
