import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/core/vendedor_sessao_provider.dart';
import 'package:tasko_mobile/common/widgets/scaffold/app_shell_scaffold.dart';
import 'package:tasko_mobile/ui/feature/cliente/adicionar/cliente_adicionar_screen.dart';
import 'package:tasko_mobile/ui/feature/cliente/listar/cliente_listar_screen.dart';
import 'package:tasko_mobile/ui/feature/cliente/manter/cliente_manter_screen.dart';
import 'package:tasko_mobile/ui/feature/cliente/tabela_preco/cliente_tabela_preco_screen.dart';
import 'package:tasko_mobile/ui/feature/home/home_screen.dart';
import 'package:tasko_mobile/ui/feature/home/modulo_placeholder_screen.dart';
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
        return '/home';
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/selecao-vendedor',
        name: 'selecao-vendedor',
        builder: (context, state) => const SelecaoVendedorScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return AppShellScaffold(
            currentLocation: state.matchedLocation,
            child: child,
          );
        },
        routes: <RouteBase>[
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
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/clientes',
            name: 'clientes',
            builder: (context, state) => const ClienteListarScreen(),
          ),
          GoRoute(
            path: '/clientes/adicionar',
            name: 'clientes-adicionar',
            builder: (context, state) => const ClienteAdicionarScreen(),
          ),
          GoRoute(
            path: '/clientes/:id',
            name: 'clientes-manter',
            builder: (context, state) {
              final clienteId = int.tryParse(state.pathParameters['id'] ?? '');
              if (clienteId == null) {
                return const ClienteListarScreen();
              }
              return ClienteManterScreen(clienteId: clienteId);
            },
          ),
          GoRoute(
            path: '/clientes/:id/tabelas-preco',
            name: 'clientes-tabelas-preco',
            builder: (context, state) {
              final clienteId = int.tryParse(state.pathParameters['id'] ?? '');
              if (clienteId == null) {
                return const ClienteListarScreen();
              }
              return ClienteTabelaPrecoScreen(clienteId: clienteId);
            },
          ),
          GoRoute(
            path: '/produtos',
            name: 'produtos',
            builder: (context, state) =>
                const ModuloPlaceholderScreen(title: 'Produtos'),
          ),
          GoRoute(
            path: '/pedidos',
            name: 'pedidos',
            builder: (context, state) =>
                const ModuloPlaceholderScreen(title: 'Pedidos'),
          ),
          GoRoute(
            path: '/agenda',
            name: 'agenda',
            builder: (context, state) =>
                const ModuloPlaceholderScreen(title: 'Agenda'),
          ),
          GoRoute(
            path: '/metas',
            name: 'metas',
            builder: (context, state) =>
                const ModuloPlaceholderScreen(title: 'Metas'),
          ),
        ],
      ),
    ],
  );
});
