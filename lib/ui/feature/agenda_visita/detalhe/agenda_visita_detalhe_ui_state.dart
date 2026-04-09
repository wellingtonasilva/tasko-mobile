import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_checkin_response.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_response.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/checkins_tipo_response.dart';

class AgendaVisitaDetalheUiState {
  final AgendaVisitaResponse? visita;
  final List<AgendaVisitaCheckinResponse> checkins;
  final List<CheckinsTipoResponse> checkinsTipos;
  final Command0 carregarDadosCommand;
  final Command0 adicionarCheckinCommand;

  AgendaVisitaDetalheUiState({
    this.visita,
    this.checkins = const [],
    this.checkinsTipos = const [],
    required this.carregarDadosCommand,
    required this.adicionarCheckinCommand,
  });

  AgendaVisitaDetalheUiState copyWith({
    AgendaVisitaResponse? visita,
    List<AgendaVisitaCheckinResponse>? checkins,
    List<CheckinsTipoResponse>? checkinsTipos,
    Command0? carregarDadosCommand,
    Command0? adicionarCheckinCommand,
  }) {
    return AgendaVisitaDetalheUiState(
      visita: visita ?? this.visita,
      checkins: checkins ?? this.checkins,
      checkinsTipos: checkinsTipos ?? this.checkinsTipos,
      carregarDadosCommand: carregarDadosCommand ?? this.carregarDadosCommand,
      adicionarCheckinCommand:
          adicionarCheckinCommand ?? this.adicionarCheckinCommand,
    );
  }
}
