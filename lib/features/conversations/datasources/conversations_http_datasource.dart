import 'package:dio/dio.dart';

import '../../chat/models/message.dart';
import '../models/conversation.dart';
import 'conversations_datasource.dart';

class ConversationsHttpDatasource implements ConversationsDatasource {
  const ConversationsHttpDatasource(this._dio);

  final Dio _dio;

  @override
  Future<List<Conversation>> list() async {
    final response = await _dio.get<Map<String, dynamic>>('/conversations');
    final items = response.data!['items'] as List<dynamic>;
    return items
        .map((item) => Conversation.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Conversation> create({String? title}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/conversations',
      // Título nulo: quem o gera é o backend, a partir da primeira pergunta.
      data: {'title': title},
    );
    return Conversation.fromJson(response.data!);
  }

  @override
  Future<void> delete(String id) => _dio.delete<void>('/conversations/$id');

  @override
  Future<List<Message>> messages(String conversationId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/conversations/$conversationId/messages',
    );
    final items = response.data!['items'] as List<dynamic>;
    return items
        .map((item) => Message.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Message> sendMessage({
    required String conversationId,
    required String content,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/conversations/$conversationId/messages',
      data: {'content': content},
    );
    return Message.fromJson(response.data!);
  }
}
