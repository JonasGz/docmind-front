import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_client.dart';
import '../../../core/config/app_config.dart';
import '../datasources/conversations_datasource.dart';
import '../datasources/conversations_http_datasource.dart';
import '../datasources/conversations_mock_datasource.dart';
import '../repositories/conversations_repository.dart';

part 'conversations_providers.g.dart';

/// Ponto de troca mock/HTTP e seam de teste, como em documentos.
@Riverpod(keepAlive: true)
ConversationsDatasource conversationsDatasource(Ref ref) {
  if (AppConfig.useMocks) {
    return ConversationsMockDatasource();
  }

  return ConversationsHttpDatasource(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
ConversationsRepository conversationsRepository(Ref ref) =>
    ConversationsRepository(ref.watch(conversationsDatasourceProvider));
