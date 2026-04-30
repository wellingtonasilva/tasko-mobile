import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/common/core/vendedor_sessao_provider.dart';
import 'package:tasko_mobile/data/repositories/agenda_visita/agenda_visita_repository_hybrid.dart';
import 'package:tasko_mobile/data/repositories/cliente/cliente_repository_hybrid.dart';
import 'package:tasko_mobile/data/repositories/vendedor/vendedor_repository_hybrid.dart';
import 'package:tasko_mobile/data/service/agenda_visita_status_service.dart';
import 'package:tasko_mobile/domain/agenda_visita/request/adicionar_agenda_visita_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_response.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_status_response.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/ui/feature/agenda_visita/criar/agenda_visita_criar_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class AgendaVisitaCriarViewModel extends Notifier<AgendaVisitaCriarUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onSalvarSucesso;

  @override
  AgendaVisitaCriarUiState build() {
    return AgendaVisitaCriarUiState(
      clientes: [],
      statusList: [],
      dataAgendada: DateTime.now(),
      carregarDadosCommand: Command0<void>(_carregarDados)..execute(),
      salvarVisitaCommand: Command1<AgendaVisitaResponse, void>(_salvarVisita),
      vendedores: [],
      vendedorSelecionado: null,
    );
  }

  int? get _vendedorSelecionadoId => ref.read(vendedorSelecionadoIdProvider);

  Future<Result<void>> _carregarDados() async {
    final clienteRepo = ref.read(clienteRepositoryHybridProvider);
    final statusService = ref.read(agendaVisitaStatusServiceProvider);
    final vendedorRepo = ref.read(vendedorRepositoryHybridProvider);

    final clienteResult = await clienteRepo.listar(
      vendedorId: _vendedorSelecionadoId,
    );
    final statusResult = await statusService.listar();
    final vendedorResult = await vendedorRepo.listar();

    state = state.copyWith(
      clientes: clienteResult is Success<List<ClienteResponse>>
          ? clienteResult.value
          : [],
      statusList: statusResult is Success<List<AgendaVisitaStatusResponse>>
          ? statusResult.value
          : [],
      vendedores: vendedorResult is Success<List<VendedorResponse>>
          ? vendedorResult.value
          : [],
    );

    return Result.success(null);
  }

  void selecionarCliente(ClienteResponse? cliente) {
    state = state.copyWith(
      clienteSelecionado: cliente,
      clearCliente: cliente == null,
    );
  }

  void selecionarStatus(AgendaVisitaStatusResponse? status) {
    state = state.copyWith(
      statusSelecionado: status,
      clearStatus: status == null,
    );
  }

  void selecionarData(DateTime data) {
    state = state.copyWith(dataAgendada: data);
  }

  void atualizarDuracao(int? duracao) {
    state = state.copyWith(
      duracaoPrevista: duracao,
      clearDuracaoPrevista: duracao == null,
    );
  }

  void atualizarObjetivo(String? objetivo) {
    state = state.copyWith(
      objetivo: objetivo,
      clearObjetivo: objetivo == null || objetivo.isEmpty,
    );
  }

  void atualizarObservacao(String? observacao) {
    state = state.copyWith(
      observacao: observacao,
      clearObservacao: observacao == null || observacao.isEmpty,
    );
  }

  void selecionarVendedor(VendedorResponse? vendedor) {
    state = state.copyWith(
      vendedorSelecionado: vendedor,
      clearVendedor: vendedor == null,
    );
  }

  Future<Result<AgendaVisitaResponse>> _salvarVisita(void _) async {
    final vendedorId = state.vendedorSelecionado?.id;
    if (vendedorId == null) {
      final Result<AgendaVisitaResponse> result = Result.failure([
        'Selecione um vendedor',
      ]);
      showSnackBar?.call('Selecione um vendedor', result);
      return result;
    }

    final now = DateTime.now();
    final uuidOffline = 'av-${now.toUtc().microsecondsSinceEpoch}';

    final request = AdicionarAgendaVisitaRequest(
      dataAgendada: state.dataAgendada.toUtc().toIso8601String(),
      duracaoPrevista: state.duracaoPrevista,
      objetivo: state.objetivo,
      observacao: state.observacao,
      vendedorId: vendedorId,
      clienteId: state.clienteSelecionado?.id,
      agendaVisitaStatusId: state.statusSelecionado?.id,
      criadoOffline: true,
      uuidOffline: uuidOffline,
    );

    final repository = ref.read(agendaVisitaRepositoryHybridProvider);
    final result = await repository.adicionar(request);

    if (result is Success<AgendaVisitaResponse>) {
      showSnackBar?.call('Visita agendada com sucesso!', result);
      onSalvarSucesso?.call();
    } else if (result is Failure<AgendaVisitaResponse>) {
      showSnackBar?.call(result.errors?[0] ?? 'Erro ao agendar visita', result);
    }

    return result;
  }
}

final agendaVisitaCriarViewModelProvider =
    NotifierProvider<AgendaVisitaCriarViewModel, AgendaVisitaCriarUiState>(
      AgendaVisitaCriarViewModel.new,
    );
