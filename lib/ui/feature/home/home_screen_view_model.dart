import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/common/core/auth_persistence.dart';
import 'package:tasko_mobile/ui/feature/home/home_screen_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class HomeScreenViewModel extends Notifier<HomeScreenUiState> {
  @override
  HomeScreenUiState build() {
    return HomeScreenUiState(
      lastLoginCommand: Command0<void>(_refreshLoginData),
    );
  }

  Future<Result<void>> _refreshLoginData() async {
    final usuarioLoginResponse = await ref
        .read(authLocalStorageProvider)
        .getUsuarioLoginResponse();
    state = state.copyWith(usuarioLoginResponse: usuarioLoginResponse);
    return Result.success(null);
  }

  String get welcomeMessage {
    if (state.usuarioLoginResponse?.vendedor != null) {
      return 'Bem-vindo, ${state.usuarioLoginResponse!.vendedor!.nomeVendedor}';
    } else if (state.usuarioLoginResponse != null) {
      return 'Bem-vindo, Admin';
    } else {
      return 'Bem-vindo!';
    }
  }

  bool get isAdmin {
    return state.usuarioLoginResponse?.perfis.any(
          (perfil) => perfil.perfilTipo == 'ROLE_ADMIN',
        ) ??
        false;
  }
}

final homeScreenViewModelProvider =
    NotifierProvider<HomeScreenViewModel, HomeScreenUiState>(
      () => HomeScreenViewModel(),
    );
