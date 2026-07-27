import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../conversations/providers/conversations_providers.dart';
import '../models/message.dart';
import '../models/message_role.dart';

part 'chat_viewmodel.g.dart';

class ChatState {
  const ChatState({
    this.conversationId,
    this.messages = const [],
    this.isAwaitingAnswer = false,
    this.sendError,
  });

  final String? conversationId;

  final List<Message> messages;

  final bool isAwaitingAnswer;

  final Object? sendError;

  bool get isEmpty => messages.isEmpty;

  ChatState copyWith({
    String? conversationId,
    List<Message>? messages,
    bool? isAwaitingAnswer,
    Object? sendError = _unset,
  }) {
    return ChatState(
      conversationId: conversationId ?? this.conversationId,
      messages: messages ?? this.messages,
      isAwaitingAnswer: isAwaitingAnswer ?? this.isAwaitingAnswer,
      sendError: identical(sendError, _unset) ? this.sendError : sendError,
    );
  }

  static const _unset = Object();
}

@riverpod
class ChatViewModel extends _$ChatViewModel {
  @override
  ChatState build() => const ChatState();

  Future<void> openConversation(String conversationId) async {
    state = ChatState(conversationId: conversationId);

    final messages = await ref
        .read(conversationsRepositoryProvider)
        .messages(conversationId);

    state = state.copyWith(messages: messages);
  }

  void startNewConversation() => state = const ChatState();

  Future<void> send(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty || state.isAwaitingAnswer) return;

    final repository = ref.read(conversationsRepositoryProvider);

    final pending = Message(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      role: MessageRole.user,
      content: trimmed,
      sources: null,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, pending],
      isAwaitingAnswer: true,
      sendError: null,
    );

    try {
      final conversationId =
          state.conversationId ?? (await repository.create()).id;

      final answer = await repository.sendMessage(
        conversationId: conversationId,
        content: trimmed,
      );

      state = state.copyWith(
        conversationId: conversationId,
        messages: [...state.messages, answer],
        isAwaitingAnswer: false,
      );
    } on Object catch (error) {
      state = state.copyWith(
        messages: state.messages.where((m) => m.id != pending.id).toList(),
        isAwaitingAnswer: false,
        sendError: error,
      );
    }
  }

  void clearError() => state = state.copyWith(sendError: null);
}
