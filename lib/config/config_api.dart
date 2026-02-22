import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    apiHost: dotenv.env['API_HOST'] ?? 'localhost',
    apiPort: int.tryParse(dotenv.env['API_PORT'] ?? ''),
    isDevelopment: dotenv.env['IS_DEVELOPMENT'] == 'true',
  );
});
