import '../../chat/models/message.dart';
import '../models/conversation.dart';

abstract interface class ConversationsDatasource {
  Future<List<Conversation>> list();

  Future<Conversation> create({String? title});

  Future<void> delete(String id);

  Future<List<Message>> messages(String conversationId);

  Future<Message> sendMessage({
    required String conversationId,
    required String content,
  });
}
