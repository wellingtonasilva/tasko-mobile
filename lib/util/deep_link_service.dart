import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:go_router/go_router.dart';

class DeepLinkService {
  static final AppLinks _appLinks = AppLinks();

  static Future<void> init() async {
    final uri = await _appLinks.getInitialAppLink();

    if (uri != null) {
      _handleInitialLink(uri);
    }
  }

  static void _handleInitialLink(Uri uri) {
    _initialUri = uri;
  }

  static Uri? _initialUri;

  static Uri? getInitialUri() => _initialUri;

  static void listen(Function(Uri) onLink) {
    _appLinks.uriLinkStream.listen((uri) {
      if (uri.path == '/reset-password') {
        final token = uri.queryParameters['token'];

        onLink(uri);
      }
    });
  }
}
