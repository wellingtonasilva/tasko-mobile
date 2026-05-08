import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/domain/common/configuracao.dart';
import 'package:tasko_mobile/ui/feature/configuracao/configuracao_ui_state.dart';

class ConfiguracaoViewModel extends Notifier<ConfiguracaoUiState> {
  @override
  ConfiguracaoUiState build() {
    return ConfiguracaoUiState(
      configuracaoSections: {
        'Cadastros': [
          Configuracao(
            key: 'territorio',
            label: 'Território',
            prefixIcon: Icons.map,
          ),
          Configuracao(
            key: 'supervisores',
            label: 'Supervisores',
            prefixIcon: Icons.supervisor_account,
          ),
          Configuracao(
            key: 'grupos',
            label: 'Grupos',
            prefixIcon: Icons.category,
          ),
          Configuracao(
            key: 'formas-pagamento',
            label: 'Formas de Pagamento',
            prefixIcon: Icons.payments,
          ),
          Configuracao(
            key: 'condicoes-pagamento',
            label: 'Condições de Pagamento',
            prefixIcon: Icons.monetization_on,
          ),
        ],
        'Sistema': [
          Configuracao(
            key: 'usuarios',
            label: 'Usuários',
            prefixIcon: Icons.person,
          ),
          Configuracao(
            key: 'sincronizacao',
            label: 'Sincronização',
            prefixIcon: Icons.sync,
          ),
        ],
        'App': [
          Configuracao(
            key: 'sobre-aplicativo',
            label: 'Sobre o Aplicativo',
            prefixIcon: Icons.info_outline,
          ),
        ],
      },
    );
  }
}

final configuracaoViewModelProvider =
    NotifierProvider.autoDispose<ConfiguracaoViewModel, ConfiguracaoUiState>(
      () => ConfiguracaoViewModel(),
    );
