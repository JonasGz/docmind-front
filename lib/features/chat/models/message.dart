import 'package:freezed_annotation/freezed_annotation.dart';

import 'message_role.dart';
import 'source.dart';

part 'message.freezed.dart';
part 'message.g.dart';

/// Espelha `MessageResponse` do backend (`app/schemas/conversation.py`).
///
/// `sources` só vem preenchido em mensagens do assistente, e ainda assim
/// pode ser nulo ou vazio quando nenhum trecho passou do limiar de
/// similaridade — caso em que o backend responde que não encontrou base nos
/// documentos.
@freezed
abstract class Message with _$Message {
  const factory Message({
    required String id,
    required MessageRole role,
    required String content,
    required List<Source>? sources,
    required DateTime createdAt,
  }) = _Message;

  const Message._();

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  bool get hasSources => sources != null && sources!.isNotEmpty;
}
