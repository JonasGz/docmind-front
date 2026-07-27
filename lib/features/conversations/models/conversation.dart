import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

/// Espelha `ConversationResponse` do backend
/// (`app/schemas/conversation.py`).
///
/// O título é gerado pelo backend a partir da primeira pergunta — o
/// aplicativo envia `title` nulo ao criar e nunca pergunta nada ao usuário.
@freezed
abstract class Conversation with _$Conversation {
  const factory Conversation({
    required String id,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}
