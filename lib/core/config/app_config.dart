abstract final class AppConfig {
  static const useMocks = bool.fromEnvironment('USE_MOCKS', defaultValue: true);

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  static const googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
  );
}
