class AppConfig {
  static const mapsApiKey = String.fromEnvironment('MAPS_API_KEY');
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.102.24:8085/ecom_db',
  );
  // ── Auth ─────────────────────────────────────────────────────────────────


  // ── HomePage ───────────────────────────────────────────────────────────

}
