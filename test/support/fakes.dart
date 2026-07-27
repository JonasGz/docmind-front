import 'dart:typed_data';

import 'package:docmind/features/chat/models/message.dart';
import 'package:docmind/features/chat/models/message_role.dart';
import 'package:docmind/features/chat/models/source.dart';
import 'package:docmind/features/conversations/datasources/conversations_datasource.dart';
import 'package:docmind/features/conversations/models/conversation.dart';
import 'package:docmind/features/documents/datasources/documents_datasource.dart';
import 'package:docmind/features/documents/models/document.dart';
import 'package:docmind/features/documents/models/document_status.dart';
import 'package:docmind/features/documents/models/document_type.dart';

/// Datasources controlados — a seam única de teste, injetada por override.

Document indexedDoc(
  String id, {
  String filename = 'Documento.pdf',
  String? title,
  int? pageCount = 10,
}) {
  final now = DateTime.now();
  return Document(
    id: id,
    filename: filename,
    status: DocumentStatus.indexed,
    title: title,
    docType: DocumentType.contrato,
    rawDocType: null,
    identifiers: null,
    pageCount: pageCount,
    chunkCount: 20,
    errorMessage: null,
    createdAt: now,
    updatedAt: now,
  );
}

class FakeDocumentsDatasource implements DocumentsDatasource {
  FakeDocumentsDatasource([this.documents = const []]);

  List<Document> documents;
  Object? listError;
  int listCalls = 0;

  @override
  Future<List<Document>> list() async {
    listCalls++;
    if (listError case final error?) throw error;
    return documents;
  }

  @override
  Future<Document> byId(String id) async =>
      documents.firstWhere((d) => d.id == id);

  @override
  Future<Document> upload({
    required String filename,
    required Uint8List bytes,
  }) async {
    final now = DateTime.now();
    final document = Document(
      id: 'up-${now.microsecondsSinceEpoch}',
      filename: filename,
      status: DocumentStatus.uploaded,
      title: null,
      docType: null,
      rawDocType: null,
      identifiers: null,
      pageCount: null,
      chunkCount: null,
      errorMessage: null,
      createdAt: now,
      updatedAt: now,
    );
    documents = [...documents, document];
    return document;
  }

  @override
  Future<void> delete(String id) async {
    documents = documents.where((d) => d.id != id).toList();
  }

  @override
  Future<String> downloadUrl(String id) async => 'fake://$id.pdf';
}

class FakeConversationsDatasource implements ConversationsDatasource {
  FakeConversationsDatasource({
    this.answerDelay = Duration.zero,
    this.withSources = true,
    this.conversations = const [],
  });

  Duration answerDelay;

  /// Falso simula a resposta sem base documental — nada passou do limiar de
  /// similaridade.
  bool withSources;

  List<Conversation> conversations;
  Object? sendError;
  int createCalls = 0;
  int deleteCalls = 0;

  final _messages = <String, List<Message>>{};
  var _sequence = 0;

  @override
  Future<List<Conversation>> list() async => conversations;

  @override
  Future<Conversation> create({String? title}) async {
    createCalls++;
    final now = DateTime.now();
    final conversation = Conversation(
      id: 'conv-$createCalls',
      title: title ?? 'Nova conversa',
      createdAt: now,
      updatedAt: now,
    );
    conversations = [...conversations, conversation];
    _messages[conversation.id] = [];
    return conversation;
  }

  @override
  Future<void> delete(String id) async {
    deleteCalls++;
    conversations = conversations.where((c) => c.id != id).toList();
    _messages.remove(id);
  }

  @override
  Future<List<Message>> messages(String conversationId) async =>
      _messages[conversationId] ?? const [];

  @override
  Future<Message> sendMessage({
    required String conversationId,
    required String content,
  }) async {
    if (answerDelay > Duration.zero) {
      await Future<void>.delayed(answerDelay);
    }
    if (sendError case final error?) throw error;

    final history = _messages.putIfAbsent(conversationId, () => []);
    history.add(
      Message(
        id: 'u-${_sequence++}',
        role: MessageRole.user,
        content: content,
        sources: null,
        createdAt: DateTime.now(),
      ),
    );

    final answer = Message(
      id: 'a-${_sequence++}',
      role: MessageRole.assistant,
      content: withSources
          ? 'Resposta com fonte.'
          : 'Não encontrei essa informação nos documentos enviados.',
      sources: withSources
          ? const [
              Source(
                documentId: 'doc-1',
                documentTitle: 'Contrato.pdf',
                page: 4,
                score: 0.8734,
                excerpt: 'A vigência do presente contrato será de 30 meses…',
              ),
            ]
          : const [],
      createdAt: DateTime.now(),
    );

    history.add(answer);
    return answer;
  }
}
