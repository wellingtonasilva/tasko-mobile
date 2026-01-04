import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/util/command.dart';

class VendedorListarUiState {
  final List<VendedorResponse> vendedores;
  final Command0 listarVendedoresCommand;
  final Command1 excluirVendedorCommand;

  VendedorListarUiState({
    required this.vendedores,
    required this.listarVendedoresCommand,
    required this.excluirVendedorCommand,
  });

  VendedorListarUiState copyWith({
    List<VendedorResponse>? vendedores,
    Command0? listarVendedoresCommand,
    Command1? excluirVendedorCommand,
  }) {
    return VendedorListarUiState(
      vendedores: vendedores ?? this.vendedores,
      listarVendedoresCommand:
          listarVendedoresCommand ?? this.listarVendedoresCommand,
      excluirVendedorCommand:
          excluirVendedorCommand ?? this.excluirVendedorCommand,
    );
  }
}
