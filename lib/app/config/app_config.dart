class AppConfig {
  static const String mapsApiKey =
  String.fromEnvironment('MAPS_API_KEY');

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api/v1',
  );

  // ── Auth ────────────────────────────────────────
  static const String signIn = '/auth/sign-in';
  static const String signUp = '/auth/sign-up';

  // ── Home ────────────────────────────────────────
  static const String home = '/home';
}