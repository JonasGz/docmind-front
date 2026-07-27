// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversations_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ConversationsViewModel)
final conversationsViewModelProvider = ConversationsViewModelProvider._();

final class ConversationsViewModelProvider
    extends $AsyncNotifierProvider<ConversationsViewModel, List<Conversation>> {
  ConversationsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conversationsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conversationsViewModelHash();

  @$internal
  @override
  ConversationsViewModel create() => ConversationsViewModel();
}

String _$conversationsViewModelHash() =>
    r'b8d28931f30e6611dc7bab8de40d526c6d657055';

abstract class _$ConversationsViewModel
    extends $AsyncNotifier<List<Conversation>> {
  FutureOr<List<Conversation>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<Conversation>>, List<Conversation>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Conversation>>, List<Conversation>>,
              AsyncValue<List<Conversation>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
