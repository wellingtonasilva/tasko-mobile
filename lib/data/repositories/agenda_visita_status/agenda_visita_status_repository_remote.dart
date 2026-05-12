import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/agenda_visita_status/agenda_visita_status_repository.dart';
import 'package:tasko_mobile/data/service/agenda_visita_status_service.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_status_response.dart';
import 'package:tasko_mobile/util/result.dart';

class AgendaVisitaStatusRepositoryRemote
    implements AgendaVisitaStatusRepository {
  final AgendaVisitaStatusService _agendaVisitaStatusService;
  AgendaVisitaStatusRepositoryRemote(this._agendaVisitaStatusService);

  @override
  Future<Result<List<AgendaVisitaStatusResponse>>> listar() {
    return _agendaVisitaStatusService.listar();
  }

  @override
  Future<Result<AgendaVisitaStatusResponse>> obterPorId(int id) {
    return _agendaVisitaStatusService.obterPorId(id);
  }
}

final agendaVisitaStatusRepositoryRemoteProvider =
    Provider<AgendaVisitaStatusRepositoryRemote>(
      (ref) => AgendaVisitaStatusRepositoryRemote(
        ref.read(agendaVisitaStatusServiceProvider),
      ),
    );
