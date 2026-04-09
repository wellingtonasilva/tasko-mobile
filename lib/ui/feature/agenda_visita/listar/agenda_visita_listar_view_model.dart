import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/common/core/vendedor_sessao_provider.dart';
import 'package:tasko_mobile/data/repositories/agenda_visita/agenda_visita_repository_hybrid.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_response.dart';
import 'package:tasko_mobile/ui/feature/agenda_visita/listar/agenda_visita_listar_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class AgendaVisitaListarViewModel extends Notifier<AgendaVisitaListarUiState> {
  void Function(String, Result result)? showSnackBar;

  @override
  AgendaVisitaListarUiState build() {
    return AgendaVisitaListarUiState(
      visitas: [],
      dataSelecionada: DateTime.now(),
      listarVisitasCommand: Command0<void>(_listarVisitas)..execute(),
      excluirVisitaCommand: Command1<void, int>(_excluirVisita),
    );
  }

  int? get _vendedorSelecionadoId => ref.read(vendedorSelecionadoIdProvider);

  Future<Result<void>> _listarVisitas() async {
    final repository = ref.read(agendaVisitaRepositoryHybridProvider);
    final vendedorId = _vendedorSelecionadoId;

    final result = vendedorId != null
        ? await repository.listarPorData(vendedorId, state.dataSelecionada)
        : await repository.listar();

    if (result is Success<List<AgendaVisitaResponse>>) {
      state = state.copyWith(visitas: result.value);
      unawaited(_sincronizarEmBackground(repository));
    } else if (result is Failure) {
      state = state.copyWith(visitas: []);
      showSnackBar?.call(
        (result as Failure).errors?[0] ?? 'Erro ao carregar agenda',
        result,
      );
    }

    return result;
  }

  Future<void> _sincronizarEmBackground(
    AgendaVisitaRepositoryHybrid repository,
  ) async {
    final syncResult = await repository.sincronizarListaComServidor(
      vendedorId: _vendedorSelecionadoId,
    );
    if (syncResult is Success<List<AgendaVisitaResponse>>) {
      final vendedorId = _vendedorSelecionadoId;
      if (vendedorId != null) {
        final filtradas = syncResult.value
            .where(
              (v) =>
                  v.vendedorId == vendedorId &&
                  _isSameDay(v.dataAgendada, state.dataSelecionada),
            )
            .toList();
        state = state.copyWith(visitas: filtradas);
      } else {
        state = state.copyWith(visitas: syncResult.value);
      }
    }
  }

  void selecionarData(DateTime data) {
    state = state.copyWith(dataSelecionada: data);
    state.listarVisitasCommand.execute();
  }

  Future<Result<void>> _excluirVisita(int id) async {
    final repository = ref.read(agendaVisitaRepositoryHybridProvider);
    final result = await repository.excluir(id);
    if (result is Success<void>) {
      await _listarVisitas();
      showSnackBar?.call('Visita excluida com sucesso!', result);
    } else if (result is Failure<void>) {
      showSnackBar?.call(result.errors?[0] ?? 'Erro ao excluir visita', result);
    }
    return result;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

final agendaVisitaListarViewModelProvider =
    NotifierProvider<AgendaVisitaListarViewModel, AgendaVisitaListarUiState>(
      AgendaVisitaListarViewModel.new,
    );
