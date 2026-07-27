/// Caminhos das rotas, em um só lugar para evitar strings soltas.
abstract final class Routes {
  static const login = '/login';

  static const chat = '/chat';
  static const conversations = '/chat/conversations';

  static const documents = '/documents';

  static const settings = '/settings';

  /// Visualizador de PDF, empilhado sobre a aba de origem.
  /// Recebe `:id` e, opcionalmente, `?page=`.
  static const documentViewer = 'viewer/:id';

  /// Galeria de componentes — ferramenta de desenvolvimento.
  static const gallery = '/dev/gallery';
}
