import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/data/repositories/cliente/cliente_repository_hybrid.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_tabela_preco_response.dart';
import 'package:tasko_mobile/util/result.dart';

class ClienteTabelaPrecoScreen extends BaseScreen {
  final int clienteId;

  const ClienteTabelaPrecoScreen({super.key, required this.clienteId});

  @override
  BaseScreenState<ClienteTabelaPrecoScreen> createState() =>
      _ClienteTabelaPrecoScreenState();
}

class _ClienteTabelaPrecoScreenState
    extends BaseScreenState<ClienteTabelaPrecoScreen> {
  List<ClienteTabelaPrecoResponse> _tabelas = const [];
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

    final result = await ref
        .read(clienteRepositoryHybridProvider)
        .listarTabelasPreco(widget.clienteId);

    if (!mounted) {
      return;
    }

    if (result is Success<List<ClienteTabelaPrecoResponse>>) {
      setState(() {
        _tabelas = result.value;
        _loading = false;
      });
      return;
    }

    setState(() {
      _tabelas = const [];
      _loading = false;
    });

    showSnackBar(
      (result as Failure).errors?[0] ?? 'Falha ao carregar tabelas de preco',
      isError: true,
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tabelas de Preco', style: kTestStyleBoldText24),
            const SizedBox(height: 12),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_tabelas.isEmpty)
              const Text(
                'Nenhuma tabela de preco encontrada para este cliente.',
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _tabelas.length,
                  itemBuilder: (context, index) {
                    final tabela = _tabelas[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          tabela.descricaoTabelaPreco ?? 'Sem descricao',
                        ),
                        subtitle: Text(
                          'Tabela ID: ${tabela.tabelaPrecoId ?? '-'}',
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
