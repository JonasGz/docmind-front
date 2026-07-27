import 'package:docmind/core/models/token_pair.dart';
import 'package:docmind/core/models/user.dart';
import 'package:docmind/features/chat/models/message.dart';
import 'package:docmind/features/chat/models/message_role.dart';
import 'package:docmind/features/conversations/models/conversation.dart';
import 'package:docmind/features/documents/models/document.dart';
import 'package:docmind/features/documents/models/document_status.dart';
import 'package:docmind/features/documents/models/document_type.dart';
import 'package:flutter_test/flutter_test.dart';

/// Os JSONs abaixo são o que o FastAPI realmente devolve: snake_case,
/// datas ISO 8601 com offset, UUIDs como string, enums em minúsculas.
void main() {
  group('Document', () {
    test('faz parse de um documento indexado', () {
      final doc = Document.fromJson({
        'id': '3f2b1c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d',
        'filename': 'Contrato_Locacao.pdf',
        'status': 'indexed',
        'title': 'Contrato de Locação Comercial',
        'doc_type': 'contrato',
        'raw_doc_type': 'contrato de locação',
        'identifiers': ['CNJ 0001234-56.2026.8.11.0001'],
        'page_count': 12,
        'chunk_count': 48,
        'error_message': null,
        'created_at': '2026-07-25T14:30:00Z',
        'updated_at': '2026-07-25T14:32:10Z',
      });

      expect(doc.status, DocumentStatus.indexed);
      expect(doc.docType, DocumentType.contrato);
      expect(doc.identifiers, ['CNJ 0001234-56.2026.8.11.0001']);
      expect(doc.pageCount, 12);
      expect(doc.displayName, 'Contrato de Locação Comercial');
      expect(doc.status.isReady, isTrue);
    });

    test('faz parse logo após o upload, quando quase tudo é nulo', () {
      // O POST /documents responde 202 antes de processar: neste momento o
      // backend só tem id, filename, status e datas.
      final doc = Document.fromJson({
        'id': '11111111-2222-3333-4444-555555555555',
        'filename': 'Peticao_Inicial.pdf',
        'status': 'uploaded',
        'title': null,
        'doc_type': null,
        'raw_doc_type': null,
        'identifiers': null,
        'page_count': null,
        'chunk_count': null,
        'error_message': null,
        'created_at': '2026-07-27T09:00:00Z',
        'updated_at': '2026-07-27T09:00:00Z',
      });

      expect(doc.status.isPending, isTrue);
      expect(doc.docType, isNull);
      // Sem título extraído, cai no nome do arquivo.
      expect(doc.displayName, 'Peticao_Inicial.pdf');
    });

    test('faz parse de uma falha de processamento', () {
      final doc = Document.fromJson({
        'id': '99999999-8888-7777-6666-555555555555',
        'filename': 'Corrompido.pdf',
        'status': 'failed',
        'title': null,
        'doc_type': null,
        'raw_doc_type': null,
        'identifiers': null,
        'page_count': null,
        'chunk_count': null,
        'error_message': 'Não foi possível extrair texto do PDF',
        'created_at': '2026-07-27T09:00:00Z',
        'updated_at': '2026-07-27T09:01:00Z',
      });

      expect(doc.status.hasFailed, isTrue);
      expect(doc.errorMessage, isNotNull);
    });

    test('status ou tipo desconhecido não derruba o parse', () {
      // Se o backend ganhar uma categoria nova, a lista do usuário continua
      // abrindo em vez de estourar exceção.
      final doc = Document.fromJson({
        'id': 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee',
        'filename': 'Novidade.pdf',
        'status': 'quarantined',
        'title': null,
        'doc_type': 'acordao',
        'raw_doc_type': null,
        'identifiers': null,
        'page_count': null,
        'chunk_count': null,
        'error_message': null,
        'created_at': '2026-07-27T09:00:00Z',
        'updated_at': '2026-07-27T09:00:00Z',
      });

      expect(doc.status, DocumentStatus.unknown);
      expect(doc.docType, DocumentType.unknown);
    });

    test('ida e volta por JSON preserva os campos', () {
      const json = {
        'id': '3f2b1c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d',
        'filename': 'Contrato.pdf',
        'status': 'indexed',
        'title': 'Contrato',
        'doc_type': 'contrato',
        'raw_doc_type': null,
        'identifiers': <String>[],
        'page_count': 3,
        'chunk_count': 9,
        'error_message': null,
        'created_at': '2026-07-25T14:30:00.000Z',
        'updated_at': '2026-07-25T14:30:00.000Z',
      };

      expect(
        Document.fromJson(Document.fromJson(json).toJson()),
        Document.fromJson(json),
      );
    });
  });

  group('Message e Source', () {
    test('faz parse de resposta do assistente com fontes', () {
      final message = Message.fromJson({
        'id': 'cccccccc-dddd-eeee-ffff-000000000000',
        'role': 'assistant',
        'content': 'O contrato tem vigência de 30 meses.',
        'sources': [
          {
            'document_id': '3f2b1c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d',
            'document_title': 'Contrato_Locacao.pdf',
            'page': 4,
            'score': 0.8734,
            'excerpt': 'A vigência do presente contrato será de 30 meses…',
          },
        ],
        'created_at': '2026-07-27T10:15:00Z',
      });

      expect(message.role, MessageRole.assistant);
      expect(message.hasSources, isTrue);

      final source = message.sources!.single;
      expect(source.page, 4);
      expect(source.score, closeTo(0.8734, 0.0001));
      expect(source.label, 'Contrato_Locacao.pdf · pág. 4');
      expect(source.scoreLabel, '87%');
    });

    test('mensagem do usuário não tem fontes', () {
      final message = Message.fromJson({
        'id': 'bbbbbbbb-cccc-dddd-eeee-ffffffffffff',
        'role': 'user',
        'content': 'Qual o prazo de vigência?',
        'sources': null,
        'created_at': '2026-07-27T10:14:00Z',
      });

      expect(message.role.isUser, isTrue);
      expect(message.hasSources, isFalse);
    });

    test('resposta sem base nos documentos vem com sources vazio', () {
      // Quando nada passa do SIMILARITY_THRESHOLD, o backend responde que
      // não encontrou base — e a lista vem vazia, não nula.
      final message = Message.fromJson({
        'id': 'dddddddd-eeee-ffff-0000-111111111111',
        'role': 'assistant',
        'content': 'Não encontrei essa informação nos documentos enviados.',
        'sources': <Map<String, dynamic>>[],
        'created_at': '2026-07-27T10:16:00Z',
      });

      expect(message.sources, isEmpty);
      expect(message.hasSources, isFalse);
    });
  });

  group('Conversation', () {
    test('faz parse com o título gerado pelo backend', () {
      final conversation = Conversation.fromJson({
        'id': '77777777-8888-9999-aaaa-bbbbbbbbbbbb',
        'title': 'Prazo de vigência do contrato de locação',
        'created_at': '2026-07-27T10:14:00Z',
        'updated_at': '2026-07-27T10:16:00Z',
      });

      expect(conversation.title, 'Prazo de vigência do contrato de locação');
      expect(conversation.updatedAt.isAfter(conversation.createdAt), isTrue);
    });
  });

  group('User', () {
    test('faz parse e deriva as iniciais do nome', () {
      final user = User.fromJson({
        'id': '12345678-90ab-cdef-1234-567890abcdef',
        'email': 'marina.barros@gmail.com',
        'name': 'Marina Barros',
        'created_at': '2026-01-10T08:00:00Z',
      });

      expect(user.displayName, 'Marina Barros');
      expect(user.initials, 'MB');
    });

    test('sem nome, cai no e-mail', () {
      final user = User.fromJson({
        'id': '12345678-90ab-cdef-1234-567890abcdef',
        'email': 'jonas@exemplo.com',
        'name': null,
        'created_at': '2026-01-10T08:00:00Z',
      });

      expect(user.displayName, 'jonas@exemplo.com');
      expect(user.initials, 'JO');
    });

    test('nome com acento e nome único não quebram as iniciais', () {
      expect(
        User.fromJson({
          'id': 'x',
          'email': 'a@b.c',
          'name': 'Ângela',
          'created_at': '2026-01-10T08:00:00Z',
        }).initials,
        'ÂN',
      );

      expect(
        User.fromJson({
          'id': 'x',
          'email': 'a@b.c',
          'name': 'Maria da Silva Souza',
          'created_at': '2026-01-10T08:00:00Z',
        }).initials,
        'MS',
      );
    });
  });

  group('TokenPair', () {
    test('faz parse e assume bearer quando o tipo é omitido', () {
      final tokens = TokenPair.fromJson({
        'access_token': 'eyJhbGciOi...',
        'refresh_token': 'eyJhbGciOi...refresh',
        'token_type': 'bearer',
      });

      expect(tokens.accessToken, 'eyJhbGciOi...');
      expect(tokens.tokenType, 'bearer');
    });
  });
}
