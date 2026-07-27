import '../../chat/models/message.dart';
import '../datasources/conversations_datasource.dart';
import '../models/conversation.dart';

class ConversationsRepository {
  const ConversationsRepository(this._datasource);

  final ConversationsDatasource _datasource;

  Future<List<Conversation>> list() => _datasource.list();

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
