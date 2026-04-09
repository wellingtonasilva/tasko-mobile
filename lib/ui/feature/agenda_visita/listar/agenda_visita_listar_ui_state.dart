import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_response.dart';
import 'package:tasko_mobile/util/command.dart';

class AgendaVisitaListarUiState {
  final List<AgendaVisitaResponse> visitas;
  final DateTime dataSelecionada;
  final Command0 listarVisitasCommand;
  final Command1<void, int> excluirVisitaCommand;

  AgendaVisitaListarUiState({
    required this.visitas,
    required this.dataSelecionada,
    required this.listarVisitasCommand,
    required this.excluirVisitaCommand,
  });

  AgendaVisitaListarUiState copyWith({
    List<AgendaVisitaResponse>? visitas,
    DateTime? dataSelecionada,
    Command0? listarVisitasCommand,
    Command1<void, int>? excluirVisitaCommand,
  }) {
    return AgendaVisitaListarUiState(
      visitas: visitas ?? this.visitas,
      dataSelecionada: dataSelecionada ?? this.dataSelecionada,
      listarVisitasCommand: listarVisitasCommand ?? this.listarVisitasCommand,
      excluirVisitaCommand: excluirVisitaCommand ?? this.excluirVisitaCommand,
    );
  }
}
