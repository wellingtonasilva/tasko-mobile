import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/common/domain/auditoria.dart';
import 'package:tasko_mobile/common/domain/dropdown_loading_state.dart';
import 'package:tasko_mobile/data/repositories/vendedor/supervisor/vendedor_supervisor_repository_remote.dart';
import 'package:tasko_mobile/data/repositories/vendedor/territorio/vendedor_territorio_repository_remote.dart';
import 'package:tasko_mobile/data/repositories/vendedor/vendedor_repository_hybrid.dart';
import 'package:tasko_mobile/domain/vendedor/request/adicionar_vendedor_request.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_territorio_response.dart';
import 'package:tasko_mobile/ui/feature/vendedor/adicionar/vendedor_adicionar_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class VendedorAdicionarViewModel extends Notifier<VendedorAdicionarUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onAdicionarSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  VendedorAdicionarUiState build() {
    return VendedorAdicionarUiState(
      vendedorDraft: VendedorResponse(
        id: 0,
        empresaId: 0,
        auditoria: Auditoria(indicadorAtivo: true),
      ),
      adicionarCommand: Command1<VendedorResponse, AdicionarVendedorRequest>(
        _adicionar,
      ),
      listarSupervisorCommand: Command0<void>(_listarSupervisor)..execute(),
      listarTerritorioCommand: Command0<void>(_listarTerritorio)..execute(),
    );
  }

  void selectSupervisor(VendedorSupervisorResponse? supervisor) {
    state = state.copyWith(selectedSupervisor: supervisor);
  }

  void selectTerritorio(VendedorTerritorioResponse? territorio) {
    state = state.copyWith(selectedTerritorio: territorio);
  }

  void salvarDadosBasicos({
    required String codigoVendedor,
    required String nomeVendedor,
    required String numeroCPF,
    required bool indicadorAtivo,
  }) {
    onStartEvent?.call();
    final draft = state.vendedorDraft;
    if (draft == null) return;

    state = state.copyWith(
      vendedorDraft: draft.copyWith(
        codigoVendedor: codigoVendedor,
        nomeVendedor: nomeVendedor,
        numeroCPF: numeroCPF,
        auditoria: (draft.auditoria ?? Auditoria()).copyWith(
          indicadorAtivo: indicadorAtivo,
        ),
      ),
    );
    onFinishEvent?.call();
  }

  void setIndicadorAtivo(bool? indicadorAtivo) {
    if (indicadorAtivo == null) return;

    final draft = state.vendedorDraft;
    if (draft == null) return;

    state = state.copyWith(
      vendedorDraft: draft.copyWith(
        auditoria: (draft.auditoria ?? Auditoria()).copyWith(
          indicadorAtivo: indicadorAtivo,
        ),
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
    onStartEvent?.call();
    final draft = state.vendedorDraft;
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
    onFinishEvent?.call();
  }

  Future<void> enviarResumo() async {
    onStartEvent?.call();
    final draft = state.vendedorDraft;
    if (draft == null) return;

    final request = AdicionarVendedorRequest(
      codigoVendedor: draft.codigoVendedor ?? '',
      nomeVendedor: draft.nomeVendedor ?? '',
      numeroCPF: draft.numeroCPF ?? '',
      email: draft.email ?? '',
      numeroTelefone: draft.numeroTelefone ?? '',
      valorMetaMensal: draft.valorMetaMensal ?? 0,
      percentualComissao: draft.percentualComissao ?? 0,
      supervisorId:
          (state.selectedSupervisor ?? computedSelectedSupervisor)?.id ?? 0,
      territorioId:
          (state.selectedTerritorio ?? computedSelectedTerritorio)?.id ?? 0,
    );

    await state.adicionarCommand.execute(request);
    onFinishEvent?.call();
  }

  VendedorSupervisorResponse? get computedSelectedSupervisor {
    final supervisorId = (state.vendedorDraft)?.supervisor?.id;
    if (supervisorId == null || state.supervisores == null) return null;

    final found = state.supervisores!.firstWhere(
      (s) => s.id == supervisorId,
      orElse: () => VendedorSupervisorResponse(id: -1),
    );
    return found.id == -1 ? null : found;
  }

  VendedorTerritorioResponse? get computedSelectedTerritorio {
    final territorioId = state.vendedorDraft?.territorio?.id;
    if (territorioId == null || state.territorios == null) return null;

    final found = state.territorios!.firstWhere(
      (t) => t.id == territorioId,
      orElse: () => VendedorTerritorioResponse(id: -1),
    );
    return found.id == -1 ? null : found;
  }

  DropdownLoadingState get supervisorDropdownState {
    if (state.listarSupervisorCommand.running) {
      return DropdownLoadingState.loading;
    }
    if (state.listarSupervisorCommand.completed) {
      return DropdownLoadingState.ready;
    }
    return DropdownLoadingState.error;
  }

  DropdownLoadingState get territorioDropdownState {
    if (state.listarTerritorioCommand.running) {
      return DropdownLoadingState.loading;
    }
    if (state.listarTerritorioCommand.completed) {
      return DropdownLoadingState.ready;
    }
    return DropdownLoadingState.error;
  }

  Future<Result<VendedorResponse>> _adicionar(
    AdicionarVendedorRequest request,
  ) async {
    onStartEvent?.call();
    final result = await ref
        .read(vendedorRepositoryHybridProvider)
        .adicionar(request);
    if (!ref.mounted) return result;

    if (result is Success<VendedorResponse>) {
      state = state.copyWith(
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
    if (!ref.mounted) return result;
    onFinishEvent?.call();

    return result;
  }

  Future<Result<List<VendedorSupervisorResponse>>> _listarSupervisor() async {
    onStartEvent?.call();
    final result = await ref
        .read(vendedorSupervisorRepositoryRemoteProvider)
        .listar();
    if (!ref.mounted) return result;

    if (result is Success<List<VendedorSupervisorResponse>>) {
      state = state.copyWith(supervisores: result.value);
    } else if (result is Failure<List<VendedorSupervisorResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    if (!ref.mounted) return result;
    onFinishEvent?.call();

    return result;
  }

  Future<Result<List<VendedorTerritorioResponse>>> _listarTerritorio() async {
    onStartEvent?.call();
    final result = await ref
        .read(vendedorTerritorioRepositoryRemoteProvider)
        .listar();
    if (!ref.mounted) return result;

    if (result is Success<List<VendedorTerritorioResponse>>) {
      state = state.copyWith(territorios: result.value);
    } else if (result is Failure<List<VendedorTerritorioResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    if (!ref.mounted) return result;
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

final vendedorAdicionarViewModelProvider =
    NotifierProvider<VendedorAdicionarViewModel, VendedorAdicionarUiState>(
      () => VendedorAdicionarViewModel(),
    );
