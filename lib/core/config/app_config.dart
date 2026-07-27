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
}
