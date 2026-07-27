/// Configuração de ambiente, lida de `--dart-define`.
abstract final class AppConfig {
  /// Quando verdadeiro, os datasources mock substituem os HTTP. É a chave
  /// da virada da Fase 8 e permite rodar o aplicativo sem backend.
  ///
  /// `flutter run --dart-define=USE_MOCKS=false` para falar com o servidor.
  static const useMocks = bool.fromEnvironment('USE_MOCKS', defaultValue: true);

  /// URL base da API.
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  /// Client ID **web** do Google, usado como `serverClientId`. É a audiência
  /// que o backend valida — os Client IDs de iOS e Android não servem aqui.
  /// Ver SETUP.md.
  static const googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
  );
}
