/// Escala fixa de espaçamento: 4 / 8 / 12 / 16 / 24 / 32.
abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;

  /// Padding lateral de tela.
  static const screenPadding = 16.0;

  /// Topo do header, incluindo a status bar (o design usa 62px absolutos;
  /// na prática somamos o padding seguro do dispositivo — ver AppHeader).
  static const headerTopFallback = 62.0;
}

abstract final class AppRadius {
  static const sm = 6.0;
  static const md = 8.0;
  static const pill = 100.0;

  /// Squircle do ícone do app e topo do sheet de login.
  static const sheet = 22.0;
  static const appIcon = 20.0;
}

/// Alvos de toque mínimos (≥44px).
abstract final class AppSize {
  static const minTouchTarget = 44.0;
  static const signInButton = 52.0;
  static const iconButton = 44.0;
}
