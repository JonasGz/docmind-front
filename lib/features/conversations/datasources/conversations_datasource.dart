import '../../chat/models/message.dart';
import '../models/conversation.dart';

/// Superfície de dados de conversas e mensagens.
///
/// Ponto de troca entre mock e HTTP (Fase 8), como em documentos.
abstract interface class ConversationsDatasource {
  /// `GET /conversations`.
  Future<List<Conversation>> list();

  /// `POST /conversations` — 201. O `title` vai nulo: o backend o gera a
  /// partir da primeira pergunta.
  Future<Conversation> create({String? title});

  /// `DELETE /conversations/{id}` — 204.
  Future<void> delete(String id);

  /// `GET /conversations/{id}/messages`.
  Future<List<Message>> messages(String conversationId);

  /// `POST /conversations/{id}/messages` — envia a pergunta e devolve a
  /// resposta do assistente, já com as fontes recuperadas.
  Future<Message> sendMessage({
    required String conversationId,
    required String content,
  });
}
