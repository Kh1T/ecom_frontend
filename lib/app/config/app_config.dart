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
}
