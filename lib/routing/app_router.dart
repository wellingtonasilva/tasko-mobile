import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/core/vendedor_sessao_provider.dart';
import 'package:tasko_mobile/ui/feature/selecao_vendedor/selecao_vendedor_screen.dart';
import 'package:tasko_mobile/ui/feature/vendedor/adicionar/vendedor_adicionar_screen.dart';
import 'package:tasko_mobile/ui/feature/vendedor/listar/vendedor_listar_screen.dart';
import 'package:tasko_mobile/ui/feature/vendedor/manter/vendedor_manter_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final vendedorSelecionado = ref.watch(vendedorSelecionadoProvider);

  return GoRouter(
    initialLocation: '/selecao-vendedor',
    redirect: (context, state) {
      final isSelecaoRoute = state.matchedLocation == '/selecao-vendedor';

      if (vendedorSelecionado == null && !isSelecaoRoute) {
        return '/selecao-vendedor';
      }

      if (vendedorSelecionado != null && isSelecaoRoute) {
        return '/vendedores';
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/selecao-vendedor',
        name: 'selecao-vendedor',
        builder: (context, state) => const SelecaoVendedorScreen(),
      ),
      GoRoute(
        path: '/vendedores',
        name: 'vendedores-listar',
        builder: (context, state) => const VendedorListarScreen(),
      ),
      GoRoute(
        path: '/vendedores/adicionar',
        name: 'vendedores-adicionar',
        builder: (context, state) => const VendedorAdicionarScreen(),
      ),
      GoRoute(
        path: '/vendedores/:id',
        name: 'vendedores-manter',
        builder: (context, state) {
          final vendedorId = int.tryParse(state.pathParameters['id'] ?? '');
          if (vendedorId == null) {
            return const VendedorListarScreen();
          }
          return VendedorManterScreen(vendedorId: vendedorId);
        },
      ),
    ],
  );
});
