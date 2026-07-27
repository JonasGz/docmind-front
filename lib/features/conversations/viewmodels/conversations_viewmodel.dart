import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/conversation.dart';
import '../providers/conversations_providers.dart';

part 'conversations_viewmodel.g.dart';

@riverpod
class ConversationsViewModel extends _$ConversationsViewModel {
  @override
  Future<List<Conversation>> build() =>
      ref.read(conversationsRepositoryProvider).list();

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(conversationsRepositoryProvider).list(),
    );
  }

  Future<void> delete(String id) async {
    final previous = state.value ?? const <Conversation>[];
    state = AsyncData(previous.where((c) => c.id != id).toList());

    try {
      await ref.read(conversationsRepositoryProvider).delete(id);
    } on Object {
      state = AsyncData(previous);
      rethrow;
    }
  }
}
