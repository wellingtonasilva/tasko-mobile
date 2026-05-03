import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/core/vendedor_sessao_provider.dart';
import 'package:tasko_mobile/common/widgets/scaffold/app_shell_scaffold.dart';
import 'package:tasko_mobile/ui/feature/autenticacao/alterar_senha/create_new_password_v3_mobile_screen.dart';
import 'package:tasko_mobile/ui/feature/autenticacao/alterar_senha/reset_password_success_v3_smartphone_screen.dart';
import 'package:tasko_mobile/ui/feature/autenticacao/criar_conta/criar_conta_screen.dart';
import 'package:tasko_mobile/ui/feature/autenticacao/criar_conta/criar_conta_sucesso_screen.dart';
import 'package:tasko_mobile/ui/feature/autenticacao/login/login_screen.dart';
import 'package:tasko_mobile/ui/feature/autenticacao/recuperar_senha/recuperar_senha_screen.dart';
import 'package:tasko_mobile/ui/feature/autenticacao/resetar_senha/resetar_senha_screen.dart';
import 'package:tasko_mobile/ui/feature/cliente/adicionar/cliente_adicionar_screen.dart';
import 'package:tasko_mobile/ui/feature/cliente/listar/cliente_listar_screen.dart';
import 'package:tasko_mobile/ui/feature/cliente/manter/cliente_manter_screen.dart';
import 'package:tasko_mobile/ui/feature/cliente/tabela_preco/cliente_tabela_preco_screen.dart';
import 'package:tasko_mobile/ui/feature/home/home_screen.dart';
import 'package:tasko_mobile/ui/feature/agenda_visita/criar/agenda_visita_criar_screen.dart';
import 'package:tasko_mobile/ui/feature/agenda_visita/detalhe/agenda_visita_detalhe_screen.dart';
import 'package:tasko_mobile/ui/feature/agenda_visita/listar/agenda_visita_listar_screen.dart';
import 'package:tasko_mobile/ui/feature/home/modulo_placeholder_screen.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/pedido_criar_steps_screen.dart';
import 'package:tasko_mobile/ui/feature/pedido/listar/pedido_listar_screen.dart';
import 'package:tasko_mobile/ui/feature/produto/manter/produto_manter_screen.dart';
import 'package:tasko_mobile/ui/feature/produto/listar/produto_listar_screen.dart';
import 'package:tasko_mobile/ui/feature/selecao_vendedor/selecao_vendedor_screen.dart';
import 'package:tasko_mobile/ui/feature/vendedor/adicionar/vendedor_adicionar_screen.dart';
import 'package:tasko_mobile/ui/feature/vendedor/listar/vendedor_listar_screen.dart';
import 'package:tasko_mobile/ui/feature/vendedor/manter/vendedor_manter_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final vendedorSelecionado = ref.watch(vendedorSelecionadoProvider);

  return GoRouter(
    // initialLocation: '/selecao-vendedor',
    initialLocation: '/login',
    /*
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
    */
    routes: <RouteBase>[
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final token = state.uri.queryParameters['token'];
          return ResetarSenhaScreen(token: token);
        },
      ),
      GoRoute(
        path: '/selecao-vendedor',
        name: 'selecao-vendedor',
        builder: (context, state) => const SelecaoVendedorScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
        routes: [
          GoRoute(
            path: 'criar-password',
            name: 'criar-password',
            builder: (context, state) =>
                const CreateNewPasswordV3MobileScreen(),
          ),
          GoRoute(
            path: 'recuperar-senha',
            name: 'recuperar-senha',
            builder: (context, state) => const RecuperarSenhaScreen(),
          ),
          GoRoute(
            path: 'reset-password-success',
            name: 'reset-password-success',
            builder: (context, state) =>
                const ResetPasswordSuccessV3SmartphoneScreen(),
          ),
          GoRoute(
            path: 'criar-conta',
            name: 'criar-conta',
            builder: (context, state) => const CriarContaScreen(),
          ),
          GoRoute(
            path: 'criar-conta-sucesso',
            name: 'criar-conta-sucesso',
            builder: (context, state) => const CriarContaSucessoScreen(),
          ),
        ],
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
            builder: (context, state) => const ProdutoListarScreen(),
          ),
          GoRoute(
            path: '/produtos/:id',
            name: 'produtos-detalhe',
            builder: (context, state) {
              final produtoId = int.tryParse(state.pathParameters['id'] ?? '');
              if (produtoId == null) {
                return const ProdutoListarScreen();
              }
              return ProdutoManterScreen(produtoId: produtoId);
            },
          ),
          GoRoute(
            path: '/pedidos',
            name: 'pedidos',
            builder: (context, state) => const PedidoListarScreen(),
          ),
          GoRoute(
            path: '/pedidos/criar',
            name: 'pedidos-criar',
            builder: (context, state) => const PedidoCriarStepsScreen(),
          ),
          GoRoute(
            path: '/pedidos/:id',
            name: 'pedidos-detalhe',
            builder: (context, state) {
              final pedidoId = int.tryParse(state.pathParameters['id'] ?? '');
              if (pedidoId == null) {
                return const PedidoListarScreen();
              }
              return const PedidoListarScreen();
            },
          ),
          GoRoute(
            path: '/agenda',
            name: 'agenda',
            builder: (context, state) => const AgendaVisitaListarScreen(),
          ),
          GoRoute(
            path: '/agenda/criar',
            name: 'agenda-criar',
            builder: (context, state) => const AgendaVisitaCriarScreen(),
          ),
          GoRoute(
            path: '/agenda/:id',
            name: 'agenda-detalhe',
            builder: (context, state) {
              final agendaVisitaId = int.tryParse(
                state.pathParameters['id'] ?? '',
              );
              if (agendaVisitaId == null) {
                return const AgendaVisitaListarScreen();
              }
              return AgendaVisitaDetalheScreen(agendaVisitaId: agendaVisitaId);
            },
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
