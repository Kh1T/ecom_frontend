import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String _env(String key, {String defaultValue = ''}) {
    return dotenv.env[key] ?? defaultValue;
  }

  static String get mapsApiKey => _env('MAPS_API_KEY');

  static String get apiBaseUrl => _env(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  // ── Auth ────────────────────────────────────────
  static const String signIn = '/api/auth/sign-in';
  static const String signUp = '/api/auth/sign-up';
  static const String me = '/api/auth/me';

  /// Prefix used in the Authorization header.
  /// Set to '' (empty string) if the backend expects just the raw token.
  static String get authTokenPrefix => _env(
    'AUTH_TOKEN_PREFIX',
    defaultValue: 'Bearer',
  );

  // ── Products ────────────────────────────────────
  static const String products = '/api/v1/products';
  static const String adminProducts = '/api/v1/admin/products';

  // ── Home ────────────────────────────────────────
  static const String home = '/home';

  /// Resolves a backend path or relative URL into a full URL.
  ///
  /// If [path] already starts with `http://` or `https://`, it is returned
  /// unchanged. Otherwise it is appended to [apiBaseUrl].
  static String resolveUrl(String path) {
    final trimmed = path.trim();
    if (trimmed.isEmpty) return trimmed;
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    final base = apiBaseUrl.replaceAll(RegExp(r'/+$'), '');
    final route = trimmed.replaceAll(RegExp(r'^/+'), '');
    return '$base/$route';
  }
}
