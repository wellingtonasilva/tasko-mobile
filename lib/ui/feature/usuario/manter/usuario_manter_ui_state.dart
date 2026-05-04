import 'package:tasko_mobile/domain/usuario/request/atualizar_usuario_request.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/util/command.dart';

class UsuarioManterUiState {
  UsuarioResponse? usuario;
  final Command1<UsuarioResponse, int> obterPorIdCommand;
  final Command1<UsuarioResponse, (int id, AtualizarUsuarioRequest request)>
  atualizarUsuarioCommand;
  bool indicadorAtivo = false;
  bool isAdmin = false;

  final List<VendedorResponse> vendedores;
  final Command0 listarVendedoresCommand;
  VendedorResponse? selectedVendedor;

  UsuarioManterUiState({
    this.usuario,
    required this.obterPorIdCommand,
    required this.atualizarUsuarioCommand,
    required this.vendedores,
    required this.listarVendedoresCommand,
    this.selectedVendedor,
    this.indicadorAtivo = false,
    this.isAdmin = false,
  });

  UsuarioManterUiState copyWith({
    UsuarioResponse? usuario,
    Command1<UsuarioResponse, int>? obterPorIdCommand,
    Command1<UsuarioResponse, (int id, AtualizarUsuarioRequest request)>?
    atualizarUsuarioCommand,
    List<VendedorResponse>? vendedores,
    Command0? listarVendedoresCommand,
    VendedorResponse? selectedVendedor,
    bool? indicadorAtivo,
    bool? isAdmin,
  }) {
    return UsuarioManterUiState(
      usuario: usuario ?? this.usuario,
      obterPorIdCommand: obterPorIdCommand ?? this.obterPorIdCommand,
      atualizarUsuarioCommand:
          atualizarUsuarioCommand ?? this.atualizarUsuarioCommand,
      vendedores: vendedores ?? this.vendedores,
      listarVendedoresCommand:
          listarVendedoresCommand ?? this.listarVendedoresCommand,
      selectedVendedor: selectedVendedor ?? this.selectedVendedor,
      indicadorAtivo: indicadorAtivo ?? this.indicadorAtivo,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
