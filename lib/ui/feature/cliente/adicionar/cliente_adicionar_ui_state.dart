import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/util/command.dart';

class ClienteAdicionarUiState {
  final Command1<ClienteResponse, dynamic> adicionarCommand;

  ClienteAdicionarUiState({required this.adicionarCommand});
}
