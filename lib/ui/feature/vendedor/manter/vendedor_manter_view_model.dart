import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/common/domain/dropdown_loading_state.dart';
import 'package:tasko_mobile/data/repositories/vendedor/supervisor/vendedor_supervisor_repository_remote.dart';
import 'package:tasko_mobile/data/repositories/vendedor/territorio/vendedor_territorio_repository_remote.dart';
import 'package:tasko_mobile/data/repositories/vendedor/vendedor_repository_hybrid.dart';
import 'package:tasko_mobile/domain/vendedor/request/atualizar_vendedor.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_territorio_response.dart';
import 'package:tasko_mobile/ui/feature/vendedor/manter/vendedor_manter_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class VendedorManterViewModel extends Notifier<VendedorManterUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onAdicionarSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  VendedorManterUiState build() {
    return VendedorManterUiState(
      obterPorIdCommand: Command1<VendedorResponse, (int id,)>(_obterPorId),
      atualizarCommand:
          Command1<
            VendedorResponse,
            (int id, AtualizarVendedorRequest request)
          >(_atualizar),
      listarSupervisorCommand: Command0<void>(_listarSupervisor)..execute(),
      listarTerritorioCommand: Command0<void>(_listarTerritorio)..execute(),
    );
  }

  void selectSupervisor(VendedorSupervisorResponse? supervisor) {
    state = state.copyWith(selectedSupervisor: supervisor);
  }

  void salvarDadosBasicos({
    required String codigoVendedor,
    required String nomeVendedor,
    required String numeroCPF,
  }) {
    final draft = state.vendedorDraft ?? state.vendedor;
    if (draft == null) return;

    state = state.copyWith(
      vendedorDraft: draft.copyWith(
        codigoVendedor: codigoVendedor,
        nomeVendedor: nomeVendedor,
        numeroCPF: numeroCPF,
      ),
    );
  }

  void salvarContatoEMeta({
    required String email,
    required String numeroTelefone,
    required String valorMetaMensal,
    required String percentualComissao,
    required String? codigoDispositivo,
  }) {
    final draft = state.vendedorDraft ?? state.vendedor;
    if (draft == null) return;

    state = state.copyWith(
      vendedorDraft: draft.copyWith(
        email: email,
        numeroTelefone: numeroTelefone,
        valorMetaMensal: _parseDouble(valorMetaMensal),
        percentualComissao: _parseDouble(percentualComissao),
        codigoDispositivo: _normalizeNullable(codigoDispositivo),
      ),
    );
  }

  Future<void> enviarResumo() async {
    final draft = state.vendedorDraft ?? state.vendedor;
    if (draft == null) return;

    final request = AtualizarVendedorRequest(
      id: draft.id,
      empresaId: draft.empresaId,
      codigoVendedor: draft.codigoVendedor ?? '',
      nomeVendedor: draft.nomeVendedor ?? '',
      numeroCPF: draft.numeroCPF ?? '',
      email: draft.email ?? '',
      numeroTelefone: draft.numeroTelefone ?? '',
      valorMetaMensal: draft.valorMetaMensal ?? 0,
      percentualComissao: draft.percentualComissao ?? 0,
      codigoDispositivo: draft.codigoDispositivo,
      supervisorId: draft.supervisor?.id,
      territorioId: draft.territorio?.id,
      indicadorAtivo: true,
    );

    await state.atualizarCommand.execute((draft.id, request));
  }

  VendedorSupervisorResponse? get computedSelectedSupervisor {
    if (state.vendedor?.supervisor == null || state.supervisores == null) {
      return null;
    }

    return state.supervisores!.firstWhere(
      (s) => s.id == state.vendedor?.supervisor!.id,
      orElse: () => VendedorSupervisorResponse(id: -1),
    );
  }

  DropdownLoadingState get supervisorDropdownState {
    if (state.listarSupervisorCommand.running ||
        state.obterPorIdCommand.running) {
      return DropdownLoadingState.loading;
    }
    if (state.listarSupervisorCommand.completed &&
        state.obterPorIdCommand.completed) {
      return DropdownLoadingState.ready;
    }
    return DropdownLoadingState.error;
  }

  Future<Result<VendedorResponse>> _obterPorId((int id,) parameters) async {
    onStartEvent?.call();
    final (id,) = parameters;
    final result = await ref
        .read(vendedorRepositoryHybridProvider)
        .obterPorId(id);
    if (result is Success<VendedorResponse>) {
      state = state.copyWith(
        vendedor: result.value,
        vendedorDraft: result.value,
      );
    } else if (result is Failure<VendedorResponse>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }

  Future<Result<VendedorResponse>> _atualizar(
    (int id, AtualizarVendedorRequest request) parameters,
  ) async {
    onStartEvent?.call();
    final (id, request) = parameters;
    final result = await ref
        .read(vendedorRepositoryHybridProvider)
        .atualizar(id, request);
    if (result is Success<VendedorResponse>) {
      state = state.copyWith(
        vendedor: null,
        vendedorDraft: null,
        selectedSupervisor: null,
        selectedTerritorio: null,
      );
      onAdicionarSucesso?.call();
    } else if (result is Failure<VendedorResponse>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();

    return result;
  }

  Future<Result<List<VendedorSupervisorResponse>>> _listarSupervisor() async {
    onStartEvent?.call();
    final result = await ref
        .read(vendedorSupervisorRepositoryRemoteProvider)
        .listar();
    if (result is Success<List<VendedorSupervisorResponse>>) {
      state = state.copyWith(supervisores: result.value);
    } else if (result is Failure<List<VendedorSupervisorResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();

    return result;
  }

  Future<Result<List<VendedorTerritorioResponse>>> _listarTerritorio() async {
    onStartEvent?.call();
    final result = await ref
        .read(vendedorTerritorioRepositoryRemoteProvider)
        .listar();
    if (result is Success<List<VendedorTerritorioResponse>>) {
      state = state.copyWith(territorios: result.value);
    } else if (result is Failure<List<VendedorTerritorioResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }

  static double _parseDouble(String? value) {
    if (value == null || value.trim().isEmpty) return 0;
    final sanitized = value.replaceAll(RegExp(r'[^0-9,\.]'), '').trim();
    final normalized = sanitized.contains(',') && sanitized.contains('.')
        ? sanitized.replaceAll('.', '').replaceAll(',', '.')
        : sanitized.replaceAll(',', '.');
    return double.tryParse(normalized) ?? 0;
  }

  static String? _normalizeNullable(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}

final vendedorManterViewModelProvider =
    NotifierProvider.autoDispose<
      VendedorManterViewModel,
      VendedorManterUiState
    >(() => VendedorManterViewModel());
