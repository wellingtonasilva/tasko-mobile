import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class HttpClientConfig {
  /// Cria um cliente HTTP que ignora erros de certificado SSL
  /// ATENÇÃO: Use apenas para desenvolvimento/testes locais!
  static http.Client createInsecureClient() {
    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    return IOClient(ioClient);
  }

  /// Cria um cliente HTTP seguro (padrão)
  static http.Client createSecureClient() {
    return http.Client();
  }

  /// Retorna o cliente apropriado baseado no ambiente
  /// Para desenvolvimento local (HTTP), usa cliente inseguro
  /// Para produção (HTTPS com certificado válido), usa cliente seguro
  static http.Client getClient({required bool isDevelopment}) {
    return isDevelopment ? createInsecureClient() : createSecureClient();
  }
}

final httpClientProvider = Provider<http.Client>((ref) {
  return HttpClientConfig.getClient(isDevelopment: true);
});
