import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/card/custom_simple_item_list_card.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_response.dart';
import 'package:tasko_mobile/ui/feature/usuario/listar/usuario_listar_controllers.dart';
import 'package:tasko_mobile/ui/feature/usuario/listar/usuario_listar_view_model.dart';

class UsuarioListarScreen extends BaseScreen {
  const UsuarioListarScreen({super.key});

  @override
  BaseScreenState<UsuarioListarScreen> createState() =>
      _UsuarioListarScreenState();
}

class _UsuarioListarScreenState extends BaseScreenState<UsuarioListarScreen> {
  late final UsuarioListarControllers _controllers;

  @override
  bool get useScaffold => false;

  @override
  void initState() {
    super.initState();
    _controllers = UsuarioListarControllers();
    _controllers.pesquisar.controller.addListener(_onPesquisarChanged);

    ref.read(usuarioListarViewModelProvider).listarUsuariosCommand.execute();
  }

  @override
  void dispose() {
    _controllers.pesquisar.controller.removeListener(_onPesquisarChanged);
    _controllers.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(usuarioListarViewModelProvider);
    final usuariosFiltrados = _filtrarUsuarios(viewModel.usuarios ?? []);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: kColorStylePrimary100,
        body: RefreshIndicator(
          onRefresh: () async {
            await viewModel.listarUsuariosCommand.execute();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(color: kColorStylePrimary100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Usuários', style: kTestStyleBoldText24),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButtonPrimary(
                          label: 'Adicionar Usuário',
                          onPressed: () async {
                            final adicionado = await context.pushNamed<bool>(
                              'usuarios-adicionar',
                            );
                            if (adicionado == true) {
                              showSnackBar('Usuário adicionado com sucesso!');
                              ref
                                  .read(usuarioListarViewModelProvider)
                                  .listarUsuariosCommand
                                  .execute();
                            }
                          },
                          trailingIcon: Icons.add,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildTextField(
                          _controllers.pesquisar,
                          isShowHint: true,
                          topPadding: 0,
                        ),
                      ),
                      //Lista de Usuários
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            viewModel.listarUsuariosCommand.running
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : usuariosFiltrados.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24.0,
                                    ),
                                    child: Center(
                                      child: Text(
                                        _controllers.pesquisar.controller.text
                                                .trim()
                                                .isEmpty
                                            ? 'Nenhum usuário encontrado.'
                                            : 'Nenhum usuário encontrado para a pesquisa.',
                                        style: kTestStyleRegularText14,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: usuariosFiltrados.length,
                                    itemBuilder: (context, index) {
                                      final usuario = usuariosFiltrados[index];
                                      return CustomSimpleItemListCard(
                                        title: usuario.nomeUsuario ?? '',
                                        subtitle: 'ID: ${usuario.id}',
                                        onTap: _onCustomSimpleItemListCardTap,
                                        id: usuario.id,
                                        indicadorAtivo:
                                            usuario.auditoria?.indicadorAtivo,
                                      );
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _excluirUsuario(int id, int index, UsuarioResponse usuario) {}

  void _onPesquisarChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onCustomSimpleItemListCardTap(int id) async {
    final atualizado = await context.pushNamed<bool>(
      'usuarios-manter',
      pathParameters: {'id': id.toString()},
    );
    if (atualizado == true) {
      showSnackBar('Usuário atualizado com sucesso!');
      ref.read(usuarioListarViewModelProvider).listarUsuariosCommand.execute();
    }
  }

  List<UsuarioResponse> _filtrarUsuarios(List<UsuarioResponse> usuarios) {
    final pesquisa = _controllers.pesquisar.controller.text
        .trim()
        .toLowerCase();

    if (pesquisa.isEmpty) {
      return usuarios;
    }

    return usuarios.where((usuario) {
      final nome = usuario.nomeUsuario?.toLowerCase() ?? '';

      return nome.contains(pesquisa);
    }).toList();
  }
}
