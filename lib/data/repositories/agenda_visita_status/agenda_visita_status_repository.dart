import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_status_response.dart';
import 'package:tasko_mobile/util/result.dart';

abstract class AgendaVisitaStatusRepository {
  Future<Result<List<AgendaVisitaStatusResponse>>> listar();
  Future<Result<AgendaVisitaStatusResponse>> obterPorId(int id);
}
