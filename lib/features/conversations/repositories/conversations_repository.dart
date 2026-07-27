import '../../chat/models/message.dart';
import '../datasources/conversations_datasource.dart';
import '../models/conversation.dart';

/// Fonte única de verdade para conversas e mensagens.
class ConversationsRepository {
  const ConversationsRepository(this._datasource);

  final ConversationsDatasource _datasource;

  Future<List<Conversation>> list() => _datasource.list();

  /// O título vai nulo de propósito: quem o gera é o backend, a partir da
  /// primeira pergunta.
  Future<Conversation> create() => _datasource.create();

  Future<void> delete(String id) => _datasource.delete(id);

  Future<List<Message>> messages(String conversationId) =>
      _datasource.messages(conversationId);

  Future<Message> sendMessage({
    required String conversationId,
    required String content,
  }) =>
      _datasource.sendMessage(conversationId: conversationId, content: content);
}
