import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/app_config.dart';
import '../datasources/conversations_datasource.dart';
import '../datasources/conversations_mock_datasource.dart';
import '../repositories/conversations_repository.dart';

part 'conversations_providers.g.dart';

/// Ponto de troca mock/HTTP e seam de teste, como em documentos.
@Riverpod(keepAlive: true)
ConversationsDatasource conversationsDatasource(Ref ref) {
  if (AppConfig.useMocks) {
    return ConversationsMockDatasource();
  }

  // Fase 8: ConversationsHttpDatasource(ref.watch(dioProvider)).
  throw UnimplementedError(
    'O datasource HTTP de conversas chega na Fase 8. '
    'Rode com --dart-define=USE_MOCKS=true até lá.',
  );
}

@Riverpod(keepAlive: true)
ConversationsRepository conversationsRepository(Ref ref) =>
    ConversationsRepository(ref.watch(conversationsDatasourceProvider));
