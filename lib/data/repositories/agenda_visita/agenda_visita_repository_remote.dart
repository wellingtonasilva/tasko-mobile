import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/agenda_visita/agenda_visita_repository.dart';
import 'package:tasko_mobile/data/service/agenda_visita_checkin_service.dart';
import 'package:tasko_mobile/data/service/agenda_visita_service.dart';
import 'package:tasko_mobile/domain/agenda_visita/request/adicionar_agenda_visita_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/request/adicionar_agenda_visita_checkin_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/request/atualizar_agenda_visita_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_response.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_checkin_response.dart';
import 'package:tasko_mobile/util/result.dart';

class AgendaVisitaRepositoryRemote implements AgendaVisitaRepository {
  final AgendaVisitaService _visitaService;
  final AgendaVisitaCheckinService _checkinService;

  AgendaVisitaRepositoryRemote({
    required AgendaVisitaService visitaService,
    required AgendaVisitaCheckinService checkinService,
  }) : _visitaService = visitaService,
       _checkinService = checkinService;

  @override
  Future<Result<AgendaVisitaResponse>> adicionar(
    AdicionarAgendaVisitaRequest request,
  ) async {
    return await _visitaService.adicionar(request);
  }

  @override
  Future<Result<AgendaVisitaResponse>> atualizar(
    int id,
    AtualizarAgendaVisitaRequest request,
  ) async {
    return await _visitaService.atualizar(id, request);
  }

  @override
  Future<Result<List<AgendaVisitaResponse>>> listar({int? vendedorId}) async {
    return await _visitaService.listar();
  }

  @override
  Future<Result<List<AgendaVisitaResponse>>> listarPorData(
    int vendedorId,
    DateTime data,
  ) async {
    return await _visitaService.listar();
  }

  @override
  Future<Result<AgendaVisitaResponse>> obterPorId(int id) async {
    return await _visitaService.obterPorId(id);
  }

  @override
  Future<Result<void>> excluir(int id) async {
    return await _visitaService.excluir(id);
  }

  @override
  Future<Result<AgendaVisitaCheckinResponse>> adicionarCheckin(
    AdicionarAgendaVisitaCheckinRequest request,
  ) async {
    return await _checkinService.adicionar(request);
  }

  @override
  Future<Result<List<AgendaVisitaCheckinResponse>>> listarCheckins(
    int agendaVisitaId,
  ) async {
    return await _checkinService.listar();
  }
}

final agendaVisitaRepositoryRemoteProvider =
    Provider<AgendaVisitaRepositoryRemote>((ref) {
      final visitaService = ref.watch(agendaVisitaServiceProvider);
      final checkinService = ref.watch(agendaVisitaCheckinServiceProvider);
      return AgendaVisitaRepositoryRemote(
        visitaService: visitaService,
        checkinService: checkinService,
      );
    });
