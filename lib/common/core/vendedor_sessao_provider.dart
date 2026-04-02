import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';

class VendedorSessaoNotifier extends Notifier<VendedorResponse?> {
  @override
  VendedorResponse? build() {
    return null;
  }

  void selecionar(VendedorResponse vendedor) {
    state = vendedor;
  }

  void limpar() {
    state = null;
  }
}

final vendedorSelecionadoProvider =
    NotifierProvider<VendedorSessaoNotifier, VendedorResponse?>(
      VendedorSessaoNotifier.new,
    );

final vendedorSelecionadoIdProvider = Provider<int?>((ref) {
  return ref.watch(vendedorSelecionadoProvider)?.id;
});
