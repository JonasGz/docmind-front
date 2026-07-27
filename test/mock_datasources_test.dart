import 'dart:typed_data';

import 'package:docmind/features/chat/models/message_role.dart';
import 'package:docmind/features/conversations/datasources/conversations_mock_datasource.dart';
import 'package:docmind/features/documents/datasources/documents_mock_datasource.dart';
import 'package:docmind/features/documents/models/document_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DocumentsMockDatasource', () {
    test('lista os documentos do mais recente ao mais antigo', () async {
      final datasource = DocumentsMockDatasource(latency: Duration.zero);
      addTearDown(datasource.dispose);

      final documents = await datasource.list();

      expect(documents, isNotEmpty);
      for (var i = 1; i < documents.length; i++) {
        expect(
          documents[i - 1].createdAt.isAfter(documents[i].createdAt) ||
              documents[i - 1].createdAt == documents[i].createdAt,
          isTrue,
          reason: 'a lista deve vir ordenada por data decrescente',
        );
      }
    });

    test('inclui um documento que falhou, com a mensagem de erro', () async {
      final datasource = DocumentsMockDatasource(latency: Duration.zero);
      addTearDown(datasource.dispose);

      final failed = (await datasource.list()).firstWhere(
        (d) => d.status.hasFailed,
      );

      expect(failed.errorMessage, isNotNull);
    });

    test('upload responde em uploaded e chega a indexed depois', () async {
      final datasource = DocumentsMockDatasource(
        latency: Duration.zero,
        processingTime: const Duration(milliseconds: 40),
      );
      addTearDown(datasource.dispose);

      final uploaded = await datasource.upload(
        filename: 'Acordao_Novo.pdf',
        bytes: Uint8List(0),
      );

      // O backend responde 202 antes de processar.
      expect(uploaded.status, DocumentStatus.uploaded);
      expect(uploaded.pageCount, isNull);

      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(
        (await datasource.byId(uploaded.id)).status,
        DocumentStatus.processing,
      );

      await Future<void>.delayed(const Duration(milliseconds: 40));
      final indexed = await datasource.byId(uploaded.id);
      expect(indexed.status, DocumentStatus.indexed);
      expect(indexed.pageCount, isNotNull);
      expect(indexed.title, 'Acordao_Novo');
    });

    test('remove o documento e cancela o processamento pendente', () async {
      final datasource = DocumentsMockDatasource(
        latency: Duration.zero,
        processingTime: const Duration(milliseconds: 40),
      );
      addTearDown(datasource.dispose);

      final uploaded = await datasource.upload(
        filename: 'Temporario.pdf',
        bytes: Uint8List(0),
      );
      await datasource.delete(uploaded.id);

      expect(
        (await datasource.list()).where((d) => d.id == uploaded.id),
        isEmpty,
      );
      // O timer pendente não pode ressuscitar o documento removido.
      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(
        (await datasource.list()).where((d) => d.id == uploaded.id),
        isEmpty,
      );
    });
  });

  group('ConversationsMockDatasource', () {
    ConversationsMockDatasource build() => ConversationsMockDatasource(
      latency: Duration.zero,
      thinkingTime: Duration.zero,
    );

    test('a conversa nasce vazia e ganha título na primeira pergunta',
        () async {
      final datasource = build();

      final conversation = await datasource.create();
      expect(await datasource.messages(conversation.id), isEmpty);

      await datasource.sendMessage(
        conversationId: conversation.id,
        content: 'Qual o prazo de vigência do contrato?',
      );

      final updated = (await datasource.list()).single;
      expect(updated.title, 'Qual o prazo de vigência do contrato?');
    });

    test('responde com fontes quando a pergunta tem base documental',
        () async {
      final datasource = build();
      final conversation = await datasource.create();

      final answer = await datasource.sendMessage(
        conversationId: conversation.id,
        content: 'Qual o prazo de vigência?',
      );

      expect(answer.role, MessageRole.assistant);
      expect(answer.hasSources, isTrue);
      expect(answer.sources!.first.page, 4);
      // As fontes vêm ordenadas por relevância.
      expect(
        answer.sources!.first.score,
        greaterThan(answer.sources!.last.score),
      );
    });

    test('admite não saber quando nada bate com os documentos', () async {
      // O caso que mais importa no domínio jurídico: sem base, o assistente
      // diz que não encontrou em vez de inventar uma resposta.
      final datasource = build();
      final conversation = await datasource.create();

      final answer = await datasource.sendMessage(
        conversationId: conversation.id,
        content: 'Qual a receita de bolo de cenoura?',
      );

      expect(answer.hasSources, isFalse);
      expect(answer.content, contains('Não encontrei'));
    });

    test('o histórico guarda pergunta e resposta na ordem', () async {
      final datasource = build();
      final conversation = await datasource.create();

      await datasource.sendMessage(
        conversationId: conversation.id,
        content: 'Qual a multa por rescisão?',
      );

      final history = await datasource.messages(conversation.id);
      expect(history, hasLength(2));
      expect(history.first.role, MessageRole.user);
      expect(history.last.role, MessageRole.assistant);
    });

    test('título longo é truncado', () async {
      final datasource = build();
      final conversation = await datasource.create();

      await datasource.sendMessage(
        conversationId: conversation.id,
        content: 'Gostaria de saber, por gentileza, qual é exatamente o prazo '
            'de vigência previsto na cláusula do contrato de locação',
      );

      final title = (await datasource.list()).single.title;
      expect(title.length, lessThanOrEqualTo(48));
      expect(title, endsWith('…'));
    });
  });
}
