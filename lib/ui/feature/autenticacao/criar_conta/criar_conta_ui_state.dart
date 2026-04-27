import 'package:tasko_mobile/domain/empresa/request/criar_empresa_request.dart';
import 'package:tasko_mobile/domain/empresa/response/empresa_response.dart';
import 'package:tasko_mobile/util/command.dart';

class CriarContaUiState {
  final Command1<EmpresaResponse, CriarEmpresaRequest> criarContaCommand;

  CriarContaUiState({required this.criarContaCommand});

  CriarContaUiState copyWith({
    Command1<EmpresaResponse, CriarEmpresaRequest>? criarContaCommand,
  }) {
    return CriarContaUiState(
      criarContaCommand: criarContaCommand ?? this.criarContaCommand,
    );
  }
}
