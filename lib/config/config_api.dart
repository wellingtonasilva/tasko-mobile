import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfigApi {
  final String apiHost;
  final int? apiPort;
  final bool isDevelopment;

  ConfigApi({required this.apiHost, this.apiPort, this.isDevelopment = false});

  String get baseUrl => apiPort == null ? apiHost : '$apiHost:$apiPort';
}

final configApiProvider = Provider<ConfigApi>((ref) {
  return ConfigApi(
    apiHost: '192.168.1.96',
    apiPort: 8080,
    isDevelopment: true, // Define como true para ambiente de desenvolvimento
  );
  //return ConfigApi(apiHost: 'hgi-backend.onrender.com');
});
