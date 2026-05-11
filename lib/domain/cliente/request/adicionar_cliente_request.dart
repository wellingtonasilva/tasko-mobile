class AdicionarClienteRequest {
  final int? vendedorId;
  final int? empresaId;
  final String? codigoCliente;
  final String razaoSocial;
  final String? nomeFantasia;
  final String? cnpjCpf;
  final String? inscricaoEstadual;
  final String? tipo;
  final String? segmento;
  final String? categoria;
  final String? cep;
  final String? logradouro;
  final String? logradouroNumero;
  final String? complemento;
  final String? bairro;
  final String? cidade;
  final String? estado;
  final double? latitude;
  final double? longitude;
  final double? limiteCredito;
  final int? prazoPagamento;
  final bool? bloqueado;
  final String? motivoBloqueio;
  final String? numeroTelefone;
  final String? numeroTelefoneSecundario;
  final String? email;
  final String? observacao;

  AdicionarClienteRequest({
    this.vendedorId,
    this.empresaId,
    this.codigoCliente,
    required this.razaoSocial,
    this.nomeFantasia,
    this.cnpjCpf,
    this.inscricaoEstadual,
    this.tipo,
    this.segmento,
    this.categoria,
    this.cep,
    this.logradouro,
    this.logradouroNumero,
    this.complemento,
    this.bairro,
    this.cidade,
    this.estado,
    this.latitude,
    this.longitude,
    this.limiteCredito,
    this.prazoPagamento,
    this.bloqueado,
    this.motivoBloqueio,
    this.numeroTelefone,
    this.numeroTelefoneSecundario,
    this.email,
    this.observacao,
  });

  factory AdicionarClienteRequest.fromJson(Map<String, dynamic> json) {
    return AdicionarClienteRequest(
      vendedorId: json['vendedorId'] as int?,
      empresaId: json['empresaId'] as int?,
      codigoCliente: json['codigoCliente'] as String?,
      razaoSocial: (json['razaoSocial'] as String?) ?? '',
      nomeFantasia: json['nomeFantasia'] as String?,
      cnpjCpf: json['cnpjCpf'] as String?,
      inscricaoEstadual: json['inscricaoEstadual'] as String?,
      tipo: json['tipo'] as String?,
      segmento: json['segmento'] as String?,
      categoria: json['categoria'] as String?,
      cep: json['cep'] as String?,
      logradouro: json['logradouro'] as String?,
      logradouroNumero: json['logradouroNumero'] as String?,
      complemento: json['complemento'] as String?,
      bairro: json['bairro'] as String?,
      cidade: json['cidade'] as String?,
      estado: json['estado'] as String?,
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      limiteCredito: _toDouble(json['limiteCredito']),
      prazoPagamento: json['prazoPagamento'] as int?,
      bloqueado: json['bloqueado'] as bool?,
      motivoBloqueio: json['motivoBloqueio'] as String?,
      numeroTelefone: json['numeroTelefone'] as String?,
      numeroTelefoneSecundario: json['numeroTelefoneSecundario'] as String?,
      email: json['email'] as String?,
      observacao: json['observacao'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendedorId': vendedorId,
      'empresaId': empresaId,
      'codigoCliente': codigoCliente,
      'razaoSocial': razaoSocial,
      'nomeFantasia': nomeFantasia,
      'cnpjCpf': cnpjCpf,
      'inscricaoEstadual': inscricaoEstadual,
      'tipo': tipo,
      'segmento': segmento,
      'categoria': categoria,
      'cep': cep,
      'logradouro': logradouro,
      'logradouroNumero': logradouroNumero,
      'complemento': complemento,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'latitude': latitude,
      'longitude': longitude,
      'limiteCredito': limiteCredito,
      'prazoPagamento': prazoPagamento,
      'bloqueado': bloqueado,
      'motivoBloqueio': motivoBloqueio,
      'numeroTelefone': numeroTelefone,
      'numeroTelefoneSecundario': numeroTelefoneSecundario,
      'email': email,
      'observacao': observacao,
    };
  }

  static double? _toDouble(Object? value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
