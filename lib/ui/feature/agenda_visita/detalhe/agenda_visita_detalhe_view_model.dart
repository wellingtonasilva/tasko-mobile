import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/common/core/vendedor_sessao_provider.dart';
import 'package:tasko_mobile/data/repositories/agenda_visita/agenda_visita_repository_hybrid.dart';
import 'package:tasko_mobile/data/service/checkins_tipo_service.dart';
import 'package:tasko_mobile/domain/agenda_visita/request/adicionar_agenda_visita_checkin_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/checkins_tipo_response.dart';
import 'package:tasko_mobile/ui/feature/agenda_visita/detalhe/agenda_visita_detalhe_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class AgendaVisitaDetalheViewModel
    extends Notifier<AgendaVisitaDetalheUiState> {
  late int _agendaVisitaId;

  void Function(String message, Result result)? showSnackBar;

  int? get _vendedorSelecionadoId => ref.read(vendedorSelecionadoIdProvider);

  @override
  AgendaVisitaDetalheUiState build() {
    return AgendaVisitaDetalheUiState(
      carregarDadosCommand: Command0(_carregarDados),
      adicionarCheckinCommand: Command0(_adicionarCheckinPlaceholder),
    );
  }

  void init(int agendaVisitaId) {
    _agendaVisitaId = agendaVisitaId;
    state.carregarDadosCommand.execute();
  }

  Future<Result<void>> _adicionarCheckinPlaceholder() async {
    return Result.success(null);
  }

  Future<Result<void>> _carregarDados() async {
    final repository = ref.read(agendaVisitaRepositoryHybridProvider);
    final checkinsTipoService = ref.read(checkinsTipoServiceProvider);

    final visitaResult = await repository.obterPorId(_agendaVisitaId);
    final checkinsResult = await repository.listarCheckins(_agendaVisitaId);

    List<CheckinsTipoResponse> checkinsTipos = [];
    final tiposResult = await checkinsTipoService.listar();
    if (tiposResult is Success<List<CheckinsTipoResponse>>) {
      checkinsTipos = tiposResult.value;
    }

    if (visitaResult is Success) {
      final visita = (visitaResult as Success).value;
      final checkins = checkinsResult is Success
          ? (checkinsResult as Success).value
          : state.checkins;

      state = state.copyWith(
        visita: visita,
        checkins: checkins,
        checkinsTipos: checkinsTipos,
      );
      return Result.success(null);
    } else {
      showSnackBar?.call('Erro ao carregar dados da visita', visitaResult);
      return Result.failure(['Erro ao carregar dados']);
    }
  }

  Future<void> adicionarCheckin({
    CheckinsTipoResponse? checkinTipo,
    String? observacao,
  }) async {
    final vendedorId = _vendedorSelecionadoId;
    if (vendedorId == null) {
      showSnackBar?.call(
        'Vendedor não selecionado',
        Result.failure(['Vendedor não selecionado']),
      );
      return;
    }

    final request = AdicionarAgendaVisitaCheckinRequest(
      agendaVisitaId: _agendaVisitaId,
      vendedorId: vendedorId,
      clienteId: state.visita?.clienteId,
      checkinTipoId: checkinTipo?.id,
      observacao: observacao,
    );

    final repository = ref.read(agendaVisitaRepositoryHybridProvider);
    final result = await repository.adicionarCheckin(request);

    if (result is Success) {
      showSnackBar?.call('Check-in registrado com sucesso!', result);
      // Refresh checkins list
      final checkinsResult = await repository.listarCheckins(_agendaVisitaId);
      if (checkinsResult is Success) {
        state = state.copyWith(checkins: (checkinsResult as Success).value);
      }
    } else {
      showSnackBar?.call('Erro ao registrar check-in', result);
    }
  }
}

final agendaVisitaDetalheViewModelProvider =
    NotifierProvider<AgendaVisitaDetalheViewModel, AgendaVisitaDetalheUiState>(
      AgendaVisitaDetalheViewModel.new,
    );
