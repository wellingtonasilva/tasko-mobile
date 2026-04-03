import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/data/repositories/produto/produto_repository_hybrid.dart';
import 'package:tasko_mobile/domain/produto/response/produto_codigo_barras_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_estoque_localizacao_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_preco_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/util/result.dart';

class ProdutoDetalheScreen extends BaseScreen {
  const ProdutoDetalheScreen({super.key, required this.produtoId});

  final int produtoId;

  @override
  BaseScreenState<ProdutoDetalheScreen> createState() =>
      _ProdutoDetalheScreenState();
}

class _ProdutoDetalheScreenState extends BaseScreenState<ProdutoDetalheScreen> {
  ProdutoResponse? _produto;
  List<ProdutoPrecoResponse> _precos = const [];
  List<ProdutoEstoqueLocalizacaoResponse> _estoques = const [];
  List<ProdutoCodigoBarrasResponse> _codigos = const [];
  bool _loading = true;

  @override
  bool get useScaffold => false;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      _loading = true;
    });

    final repository = ref.read(produtoRepositoryHybridProvider);
    final produtoResult = await repository.obterPorId(widget.produtoId);

    if (produtoResult is Failure<ProdutoResponse>) {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
      showSnackBar(
        produtoResult.errors?.first ?? 'Falha ao carregar produto',
        isError: true,
      );
      return;
    }

    final precosResult = await repository.listarPrecos(
      produtoId: widget.produtoId,
    );
    final estoquesResult = await repository.listarEstoques(
      produtoId: widget.produtoId,
    );
    final codigosResult = await repository.listarCodigosBarras(
      produtoId: widget.produtoId,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _produto = (produtoResult as Success<ProdutoResponse>).value;
      _precos = precosResult is Success<List<ProdutoPrecoResponse>>
          ? precosResult.value
          : const [];
      _estoques =
          estoquesResult is Success<List<ProdutoEstoqueLocalizacaoResponse>>
          ? estoquesResult.value
          : const [];
      _codigos = codigosResult is Success<List<ProdutoCodigoBarrasResponse>>
          ? codigosResult.value
          : const [];
      _loading = false;
    });
  }

  @override
  Widget buildContent(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_produto == null) {
      return const Center(child: Text('Produto nao encontrado.'));
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_produto!.nomeProduto, style: kTestStyleBoldText24),
            const SizedBox(height: 8),
            Text(_produto!.descricaoProduto ?? '-'),
            const SizedBox(height: 16),
            _Section(
              title: 'Informacoes',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Codigo: ${_produto!.codigoProduto ?? '-'}'),
                  Text('Grupo: ${_produto!.grupoNome ?? '-'}'),
                  Text('Subgrupo: ${_produto!.subgrupoNome ?? '-'}'),
                  Text('Marca: ${_produto!.marca ?? '-'}'),
                  Text('Fornecedor: ${_produto!.fornecedor ?? '-'}'),
                  Text(
                    'Preco sugerido: ${_formatMoney(_produto!.precoSugerido)}',
                  ),
                  Text(
                    'Estoque disponivel: ${_produto!.quantidadeDisponivel?.toStringAsFixed(2) ?? '-'}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _Section(
              title: 'Precos',
              child: _precos.isEmpty
                  ? const Text('Nenhum preco encontrado.')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _precos
                          .map(
                            (preco) => Text(
                              '${preco.descricaoTabelaPreco ?? 'Tabela'}: ${_formatMoney(preco.valor)}',
                            ),
                          )
                          .toList(),
                    ),
            ),
            const SizedBox(height: 12),
            _Section(
              title: 'Estoques',
              child: _estoques.isEmpty
                  ? const Text('Nenhum estoque encontrado.')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _estoques
                          .map(
                            (estoque) => Text(
                              '${estoque.localizacao ?? 'Local'}: ${estoque.quantidadeDisponivel?.toStringAsFixed(2) ?? '-'}',
                            ),
                          )
                          .toList(),
                    ),
            ),
            const SizedBox(height: 12),
            _Section(
              title: 'Codigos de barras',
              child: _codigos.isEmpty
                  ? const Text('Nenhum codigo encontrado.')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _codigos
                          .map(
                            (codigo) => Text(
                              '${codigo.codigo} ${codigo.tipo == null ? '' : '(${codigo.tipo})'}',
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatMoney(double? value) {
    if (value == null) return '-';
    return 'R\$ ${value.toStringAsFixed(2)}';
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: kTestStyleBoldText16),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
