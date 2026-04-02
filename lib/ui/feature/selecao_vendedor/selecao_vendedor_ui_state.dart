import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/util/command.dart';

class SelecaoVendedorUiState {
  final List<VendedorResponse> vendedores;
  final Command0 carregarVendedoresCommand;

  SelecaoVendedorUiState({
    required this.vendedores,
    required this.carregarVendedoresCommand,
  });

  SelecaoVendedorUiState copyWith({
    List<VendedorResponse>? vendedores,
    Command0? carregarVendedoresCommand,
  }) {
    return SelecaoVendedorUiState(
      vendedores: vendedores ?? this.vendedores,
      carregarVendedoresCommand:
          carregarVendedoresCommand ?? this.carregarVendedoresCommand,
    );
  }
}
