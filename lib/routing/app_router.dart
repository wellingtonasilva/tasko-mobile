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
import 'package:tasko_mobile/ui/feature/condicao_pagamento/adicionar/condicao_pagamento_adicionar_screen.dart';
import 'package:tasko_mobile/ui/feature/condicao_pagamento/listar/condicao_pagamento_listar_screen.dart';
import 'package:tasko_mobile/ui/feature/condicao_pagamento/manter/condicao_pagamento_manter_screen.dart';
import 'package:tasko_mobile/ui/feature/configuracao/configuracao_screen.dart';
import 'package:tasko_mobile/ui/feature/forma_pagamento/adicionar/forma_pagamento_adicionar_screen.dart';
import 'package:tasko_mobile/ui/feature/forma_pagamento/listar/forma_pagamento_listar_screen.dart';
import 'package:tasko_mobile/ui/feature/forma_pagamento/manter/forma_pagamento_manter_screen.dart';
import 'package:tasko_mobile/ui/feature/grupo/adicionar/grupo_adicionar_screen.dart';
import 'package:tasko_mobile/ui/feature/grupo/listar/grupo_listar_screen.dart';
import 'package:tasko_mobile/ui/feature/grupo/manter/grupo_manter_screen.dart';
import 'package:tasko_mobile/ui/feature/home/home_screen.dart';
import 'package:tasko_mobile/ui/feature/agenda_visita/criar/agenda_visita_criar_screen.dart';
import 'package:tasko_mobile/ui/feature/agenda_visita/detalhe/agenda_visita_detalhe_screen.dart';
import 'package:tasko_mobile/ui/feature/agenda_visita/listar/agenda_visita_listar_screen.dart';
import 'package:tasko_mobile/ui/feature/home/modulo_placeholder_screen.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/pedido_criar_steps_screen.dart';
import 'package:tasko_mobile/ui/feature/pedido/listar/pedido_listar_screen.dart';
import 'package:tasko_mobile/ui/feature/produto/manter/produto_manter_screen.dart';
import 'package:tasko_mobile/ui/feature/produto/listar/produto_listar_screen.dart';
import 'package:tasko_mobile/ui/feature/supervisor/adicionar/supervisor_adicionar_screen.dart';
import 'package:tasko_mobile/ui/feature/supervisor/listar/supervisor_listar_screen.dart';
import 'package:tasko_mobile/ui/feature/supervisor/manter/supervisor_manter_screen.dart';
import 'package:tasko_mobile/ui/feature/territorio/adicionar/territorio_adicionar_screen.dart';
import 'package:tasko_mobile/ui/feature/territorio/listar/territorio_listar_scrren.dart';
import 'package:tasko_mobile/ui/feature/territorio/manter/territorio_manter_screen.dart';
import 'package:tasko_mobile/ui/feature/usuario/adicionar/usuario_adicionar_screen.dart';
import 'package:tasko_mobile/ui/feature/usuario/listar/usuario_listar_screen.dart';
import 'package:tasko_mobile/ui/feature/usuario/manter/usuario_manter_screen.dart';
import 'package:tasko_mobile/ui/feature/vendedor/adicionar/vendedor_adicionar_screen.dart';
import 'package:tasko_mobile/ui/feature/vendedor/listar/vendedor_listar_screen.dart';
import 'package:tasko_mobile/ui/feature/vendedor/manter/vendedor_manter_screen.dart';
import 'package:tasko_mobile/ui/feature/vendedor/metas/vendedor_metas_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  ref.watch(vendedorSelecionadoProvider);

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
        //condicoes-pagamento
        routes: <RouteBase>[
          GoRoute(
            path: '/condicoes-pagamento',
            name: 'condicoes-pagamento',
            builder: (context, state) => const CondicaoPagamentoListarScreen(),
            routes: [
              GoRoute(
                path: '/condicoes-pagamento/adicionar',
                name: 'condicoes-pagamento-adicionar',
                builder: (context, state) =>
                    const CondicaoPagamentoAdicionarScreen(),
              ),
              GoRoute(
                path: '/condicoes-pagamento/manter/:id',
                name: 'condicoes-pagamento-manter',
                builder: (context, state) {
                  final condicaoPagamentoId = int.tryParse(
                    state.pathParameters['id'] ?? '',
                  );
                  if (condicaoPagamentoId == null) {
                    return const CondicaoPagamentoListarScreen();
                  }
                  return CondicaoPagamentoManterScreen(id: condicaoPagamentoId);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/formas-pagamento',
            name: 'formas-pagamento',
            builder: (context, state) => const FormaPagamentoListarScreen(),
            routes: [
              GoRoute(
                path: '/formas-pagamento/adicionar',
                name: 'formas-pagamento-adicionar',
                builder: (context, state) =>
                    const FormaPagamentoAdicionarScreen(),
              ),
              GoRoute(
                path: '/formas-pagamento/manter/:id',
                name: 'formas-pagamento-manter',
                builder: (context, state) {
                  final formaPagamentoId = int.tryParse(
                    state.pathParameters['id'] ?? '',
                  );
                  if (formaPagamentoId == null) {
                    return const FormaPagamentoListarScreen();
                  }
                  return FormaPagamentoManterScreen(id: formaPagamentoId);
                },
              ),
            ],
          ),

          GoRoute(
            path: '/territorio',
            name: 'territorio',
            builder: (context, state) => const TerritorioListarScrren(),
            routes: [
              GoRoute(
                path: '/territorio/adicionar',
                name: 'territorio-adicionar',
                builder: (context, state) => const TerritorioAdicionarScreen(),
              ),
              GoRoute(
                path: '/territorio/:id',
                name: 'territorio-manter',
                builder: (context, state) {
                  final territorioId = int.tryParse(
                    state.pathParameters['id'] ?? '',
                  );
                  if (territorioId == null) {
                    return const TerritorioListarScrren();
                  }
                  return TerritorioManterScreen(id: territorioId);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/supervisores',
            name: 'supervisor',
            builder: (context, state) => const SupervisorListarScreen(),
          ),
          GoRoute(
            path: '/supervisores/adicionar',
            name: 'supervisor-adicionar',
            builder: (context, state) => const SupervisorAdicionarScreen(),
          ),
          GoRoute(
            path: '/supervisores/:id',
            name: 'supervisor-manter',
            builder: (context, state) {
              final supervisorId = int.tryParse(
                state.pathParameters['id'] ?? '',
              );
              if (supervisorId == null) {
                return const SupervisorListarScreen();
              }
              return SupervisorManterScreen(id: supervisorId);
            },
          ),
          GoRoute(
            path: '/configuracoes',
            name: 'configuracoes',
            builder: (context, state) => const ConfiguracaoScreen(),
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
            path: '/grupos',
            name: 'grupos',
            builder: (context, state) => const GrupoListarScreen(),
          ),
          GoRoute(
            path: '/grupos/adicionar',
            name: 'grupos-adicionar',
            builder: (context, state) => const GrupoAdicionarScreen(),
          ),
          GoRoute(
            path: '/grupos/:id',
            name: 'grupos-manter',
            builder: (context, state) {
              final grupoId = int.tryParse(state.pathParameters['id'] ?? '');
              if (grupoId == null) {
                return const GrupoListarScreen();
              }
              return GrupoManterScreen(grupoId: grupoId);
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
              return PedidoCriarStepsScreen(pedidoId: pedidoId);
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
          GoRoute(
            path: '/usuarios',
            name: 'usuarios',
            builder: (context, state) => const UsuarioListarScreen(),
            routes: [
              GoRoute(
                path: '/usuarios-adicionar',
                name: 'usuarios-adicionar',
                builder: (context, state) => const UsuarioAdicionarScreen(),
              ),
              GoRoute(
                path: '/usuarios-manter/:id',
                name: 'usuarios-manter',
                builder: (context, state) {
                  final usuarioId = int.tryParse(
                    state.pathParameters['id'] ?? '',
                  );
                  if (usuarioId == null) {
                    return const UsuarioListarScreen();
                  }
                  return UsuarioManterScreen(usuarioId: usuarioId);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/vendedor-metas/:id',
            name: 'vendedor-metas',
            builder: (context, state) {
              final vendedorId = int.tryParse(state.pathParameters['id'] ?? '');
              if (vendedorId == null) {
                return const VendedorListarScreen();
              }
              return VendedorMetasScreen(vendedorId: vendedorId);
            },
          ),
        ],
      ),
    ],
  );
});
