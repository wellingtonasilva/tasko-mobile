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
          Configuracao(label: 'Território', prefixIcon: Icons.map),
          Configuracao(
            label: 'Supervisores',
            prefixIcon: Icons.supervisor_account,
          ),
          Configuracao(label: 'Grupos', prefixIcon: Icons.category),
          Configuracao(label: 'Forma Pagamento', prefixIcon: Icons.payments),
          Configuracao(
            label: 'Condição de Pagamento',
            prefixIcon: Icons.monetization_on,
          ),
        ],
        'Sistema': [
          Configuracao(label: 'Usuários', prefixIcon: Icons.person),
          Configuracao(label: 'Sincronização', prefixIcon: Icons.sync),
        ],
        'App': [
          Configuracao(
            label: 'Sobre o Aplicativo',
            prefixIcon: Icons.info_outline,
          ),
          Configuracao(label: 'Versão', prefixIcon: Icons.tag),
        ],
      },
    );
  }
}

final configuracaoViewModelProvider =
    NotifierProvider.autoDispose<ConfiguracaoViewModel, ConfiguracaoUiState>(
      () => ConfiguracaoViewModel(),
    );
