import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/common/core/vendedor_sessao_provider.dart';
import 'package:tasko_mobile/data/repositories/vendedor/vendedor_repository_hybrid.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/ui/feature/selecao_vendedor/selecao_vendedor_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class SelecaoVendedorViewModel extends Notifier<SelecaoVendedorUiState> {
  @override
  SelecaoVendedorUiState build() {
    return SelecaoVendedorUiState(
      vendedores: [],
      carregarVendedoresCommand: Command0<void>(_carregarVendedores)..execute(),
    );
  }

  Future<Result<void>> _carregarVendedores() async {
    final repository = ref.read(vendedorRepositoryHybridProvider);
    final result = await repository.listar();

    if (result is Success<List<VendedorResponse>>) {
      state = state.copyWith(vendedores: result.value);
      unawaited(_sincronizarEmBackground(repository));
      return const Success(null);
    }

    return Result.failure((result as Failure).errors);
  }

  Future<void> _sincronizarEmBackground(
    VendedorRepositoryHybrid repository,
  ) async {
    final syncResult = await repository.sincronizarListaComServidor();
    if (syncResult is Success<List<VendedorResponse>>) {
      state = state.copyWith(vendedores: syncResult.value);
    }
  }

  void selecionarVendedor(VendedorResponse vendedor) {
    ref.read(vendedorSelecionadoProvider.notifier).selecionar(vendedor);
  }
}

final selecaoVendedorViewModelProvider =
    NotifierProvider<SelecaoVendedorViewModel, SelecaoVendedorUiState>(
      SelecaoVendedorViewModel.new,
    );
