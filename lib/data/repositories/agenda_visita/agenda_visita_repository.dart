import 'package:tasko_mobile/domain/agenda_visita/request/adicionar_agenda_visita_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/request/adicionar_agenda_visita_checkin_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/request/atualizar_agenda_visita_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_response.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_checkin_response.dart';
import 'package:tasko_mobile/util/result.dart';

abstract class AgendaVisitaRepository {
  Future<Result<AgendaVisitaResponse>> adicionar(
    AdicionarAgendaVisitaRequest request,
  );
  Future<Result<AgendaVisitaResponse>> atualizar(
    int id,
    AtualizarAgendaVisitaRequest request,
  );
  Future<Result<List<AgendaVisitaResponse>>> listar({int? vendedorId});
  Future<Result<List<AgendaVisitaResponse>>> listarPorData(
    int vendedorId,
    DateTime data,
  );
  Future<Result<AgendaVisitaResponse>> obterPorId(int id);
  Future<Result<void>> excluir(int id);
  Future<Result<AgendaVisitaCheckinResponse>> adicionarCheckin(
    AdicionarAgendaVisitaCheckinRequest request,
  );
  Future<Result<List<AgendaVisitaCheckinResponse>>> listarCheckins(
    int agendaVisitaId,
  );
}
