class AppConfig {
  static const String mapsApiKey =
  String.fromEnvironment('MAPS_API_KEY');

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  // ── Auth ────────────────────────────────────────
  static const String signIn = '/api/auth/sign-in';
  static const String signUp = '/api/auth/sign-up';

  // ── Home ────────────────────────────────────────
  static const String home = '/home';
}