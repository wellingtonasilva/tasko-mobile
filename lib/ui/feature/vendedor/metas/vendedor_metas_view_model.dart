import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/domain/common/mes_ano.dart';
import 'package:tasko_mobile/ui/feature/vendedor/metas/vendedor_metas_ui_state.dart';

class VendedorMetasViewModel extends Notifier<VendedorMetasUiState> {
  @override
  VendedorMetasUiState build() {
    return VendedorMetasUiState(mesesAnos: mesesAnos);
  }

  set mesAnoSelecionado(MesAno? value) {
    state = state.copyWith(
      mesSelecionado: value?.mes,
      anoSelecionado: value?.ano,
    );
  }

  List<MesAno> get mesesAnos {
    final List<MesAno> list = [];
    final DateTime now = DateTime.now();
    for (int i = 0; i < 12; i++) {
      final DateTime date = DateTime(now.year, now.month - i, 1);
      list.add(
        MesAno(
          date.month,
          date.year,
          '${_descricaoMes(date.month)} / ${date.year}',
        ),
      );
    }
    return list;
  }

  String _descricaoMes(int mes) {
    switch (mes) {
      case 1:
        return 'Janeiro';
      case 2:
        return 'Fevereiro';
      case 3:
        return 'Março';
      case 4:
        return 'Abril';
      case 5:
        return 'Maio';
      case 6:
        return 'Junho';
      case 7:
        return 'Julho';
      case 8:
        return 'Agosto';
      case 9:
        return 'Setembro';
      case 10:
        return 'Outubro';
      case 11:
        return 'Novembro';
      case 12:
        return 'Dezembro';
      default:
        return '';
    }
  }
}

final vendedorMetasViewModelProvider =
    NotifierProvider<VendedorMetasViewModel, VendedorMetasUiState>(
      () => VendedorMetasViewModel(),
    );
