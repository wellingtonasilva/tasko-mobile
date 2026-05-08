import 'package:tasko_mobile/domain/vendedor/response/vendedor_territorio_response.dart';
import 'package:tasko_mobile/util/command.dart';

class TerritorioListarUiState {
  final List<VendedorTerritorioResponse> territorios;
  final Command0 listarTerritoriosCommand;
  final Command1 excluirTerritorioCommand;

  TerritorioListarUiState({
    required this.territorios,
    required this.listarTerritoriosCommand,
    required this.excluirTerritorioCommand,
  });

  TerritorioListarUiState copyWith({
    List<VendedorTerritorioResponse>? territorios,
    Command0? listarTerritoriosCommand,
    Command1? excluirTerritorioCommand,
  }) {
    return TerritorioListarUiState(
      territorios: territorios ?? this.territorios,
      listarTerritoriosCommand:
          listarTerritoriosCommand ?? this.listarTerritoriosCommand,
      excluirTerritorioCommand:
          excluirTerritorioCommand ?? this.excluirTerritorioCommand,
    );
  }
}
