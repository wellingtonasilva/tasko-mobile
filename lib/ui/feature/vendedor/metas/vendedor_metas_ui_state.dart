import 'package:tasko_mobile/domain/common/mes_ano.dart';

class VendedorMetasUiState {
  List<MesAno> mesesAnos;
  int? mesSelecionado;
  int? anoSelecionado;

  VendedorMetasUiState({
    required this.mesesAnos,
    this.mesSelecionado,
    this.anoSelecionado,
  });

  VendedorMetasUiState copyWith({
    List<MesAno>? mesesAnos,
    int? mesSelecionado,
    int? anoSelecionado,
  }) {
    return VendedorMetasUiState(
      mesesAnos: mesesAnos ?? this.mesesAnos,
      mesSelecionado: mesSelecionado ?? this.mesSelecionado,
      anoSelecionado: anoSelecionado ?? this.anoSelecionado,
    );
  }
}
