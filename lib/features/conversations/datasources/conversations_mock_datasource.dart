import '../../chat/models/message.dart';
import '../../chat/models/message_role.dart';
import '../../chat/models/source.dart';
import '../models/conversation.dart';
import 'conversations_datasource.dart';

class ConversationsMockDatasource implements ConversationsDatasource {
  ConversationsMockDatasource({
    this.latency = const Duration(milliseconds: 400),
    this.thinkingTime = const Duration(milliseconds: 1200),
  });

  final Duration latency;

  final Duration thinkingTime;

  final _conversations = <Conversation>[];
  final _messages = <String, List<Message>>{};
  var _sequence = 0;

  @override
  Future<List<Conversation>> list() async {
    await Future<void>.delayed(latency);
    return List.unmodifiable(
      _conversations.toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt)),
    );
  }

  @override
  Future<Conversation> create({String? title}) async {
    await Future<void>.delayed(latency);

    final now = DateTime.now();
    final conversation = Conversation(
      id: 'conv-${now.microsecondsSinceEpoch}',

      title: title ?? 'Nova conversa',
      createdAt: now,
      updatedAt: now,
    );

    _conversations.add(conversation);
    _messages[conversation.id] = [];
    return conversation;
  }

  @override
  Future<void> delete(String id) async {
    await Future<void>.delayed(latency);
    _conversations.removeWhere((c) => c.id == id);
    _messages.remove(id);
  }

  @override
  Future<List<Message>> messages(String conversationId) async {
    await Future<void>.delayed(latency);
    return List.unmodifiable(_messages[conversationId] ?? const []);
  }

  @override
  Future<Message> sendMessage({
    required String conversationId,
    required String content,
  }) async {
    final history = _messages.putIfAbsent(conversationId, () => []);

    history.add(
      Message(
        id: 'msg-${_sequence++}',
        role: MessageRole.user,
        content: content,
        sources: null,
        createdAt: DateTime.now(),
      ),
    );

    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1 && history.length == 1) {
      _conversations[index] = _conversations[index].copyWith(
        title: _titleFrom(content),
        updatedAt: DateTime.now(),
      );
    }

    await Future<void>.delayed(thinkingTime);

    final answer = _answerFor(content);
    history.add(answer);

    if (index != -1) {
      _conversations[index] = _conversations[index].copyWith(
        updatedAt: DateTime.now(),
      );
    }

    return answer;
  }

  String _titleFrom(String question) {
    final trimmed = question.trim();
    if (trimmed.length <= 48) return trimmed;
    return '${trimmed.substring(0, 45)}…';
  }

  Message _answerFor(String question) {
    final normalized = question.toLowerCase();

    final (content, sources) = switch (normalized) {
      final q when q.contains('vigência') || q.contains('prazo') => (
        'O contrato tem vigência de 30 meses, com início em 1º de março de '
            '2026 e término em 31 de agosto de 2028. Há cláusula de renovação '
            'automática mediante aviso prévio de 90 dias.',
        [
          Source(
            documentId: 'doc-contrato-locacao',
            documentTitle: 'Contrato de Locação Comercial',
            page: 4,
            score: 0.8734,
            excerpt:
                'A vigência do presente contrato será de 30 (trinta) meses, '
                'contados a partir de 1º de março de 2026…',
          ),
          Source(
            documentId: 'doc-contrato-locacao',
            documentTitle: 'Contrato de Locação Comercial',
            page: 5,
            score: 0.7218,
            excerpt:
                'Parágrafo único. A renovação dar-se-á automaticamente, salvo '
                'manifestação em contrário com antecedência de 90 dias.',
          ),
        ],
      ),
      final q when q.contains('multa') || q.contains('rescis') => (
        'A rescisão antecipada sujeita a parte à multa equivalente a três '
            'aluguéis vigentes, reduzida proporcionalmente ao tempo já '
            'cumprido do contrato.',
        [
          Source(
            documentId: 'doc-contrato-locacao',
            documentTitle: 'Contrato de Locação Comercial',
            page: 9,
            score: 0.8102,
            excerpt:
                'Em caso de rescisão imotivada, a parte infratora pagará multa '
                'correspondente a 3 (três) aluguéis…',
          ),
        ],
      ),
      final q when q.contains('licitaç') || q.contains('pregão') => (
        'O parecer conclui pela regularidade do Pregão Eletrônico 014/2026, '
            'ressalvando a necessidade de republicação do edital em razão da '
            'alteração no prazo de entrega.',
        [
          Source(
            documentId: 'doc-parecer',
            documentTitle: 'Parecer Jurídico — Pregão Eletrônico 014/2026',
            page: 31,
            score: 0.7945,
            excerpt:
                'Opina-se pela regularidade do certame, condicionada à '
                'republicação do edital…',
          ),
        ],
      ),

      _ => (
        'Não encontrei essa informação nos documentos enviados. Tente '
            'reformular a pergunta ou envie o documento que a contenha.',
        <Source>[],
      ),
    };

    return Message(
      id: 'msg-${_sequence++}',
      role: MessageRole.assistant,
      content: content,
      sources: sources,
      createdAt: DateTime.now(),
    );
  }
}
