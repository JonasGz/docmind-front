import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/document.dart';
import '../providers/documents_providers.dart';

part 'documents_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class DocumentsViewModel extends _$DocumentsViewModel {
  static const _pollInterval = Duration(seconds: 2);

  Timer? _timer;
  _LifecycleWatcher? _lifecycle;

  @override
  Future<List<Document>> build() async {
    ref.onDispose(() {
      _timer?.cancel();
      _lifecycle?.dispose();
    });

    _lifecycle ??= _LifecycleWatcher(
      onResume: () {
        unawaited(refresh());
      },
      onPause: _stopPolling,
    );

    final documents = await ref.read(documentsRepositoryProvider).list();
    _syncPolling(documents);
    return documents;
  }

  Future<void> refresh() async {
    try {
      final documents = await ref.read(documentsRepositoryProvider).list();
      state = AsyncData(documents);
      _syncPolling(documents);
    } on Object catch (error, stack) {
      if (!state.hasValue) state = AsyncError(error, stack);
    }
  }

  Future<void> upload({
    required String filename,
    required Uint8List bytes,
  }) async {
    final document = await ref
        .read(documentsRepositoryProvider)
        .upload(filename: filename, bytes: bytes);

    state = AsyncData([document, ...state.value ?? const []]);
    _syncPolling(state.requireValue);
  }

  Future<void> delete(String id) async {
    final previous = state.value ?? const <Document>[];

    state = AsyncData(previous.where((d) => d.id != id).toList());

    try {
      await ref.read(documentsRepositoryProvider).delete(id);
      _syncPolling(state.requireValue);
    } on Object {
      state = AsyncData(previous);
      rethrow;
    }
  }

  void _syncPolling(List<Document> documents) {
    final hasPending = documents.any((d) => d.status.isPending);

    if (!hasPending) {
      _stopPolling();
      return;
    }

    _timer ??= Timer.periodic(_pollInterval, (_) => unawaited(refresh()));
  }

  void _stopPolling() {
    _timer?.cancel();
    _timer = null;
  }
}

@riverpod
int indexedDocumentCount(Ref ref) {
  final documents = ref.watch(documentsViewModelProvider).value;
  return documents?.where((d) => d.status.isReady).length ?? 0;
}

class _LifecycleWatcher with WidgetsBindingObserver {
  _LifecycleWatcher({required this.onResume, required this.onPause}) {
    WidgetsBinding.instance.addObserver(this);
  }

  final VoidCallback onResume;
  final VoidCallback onPause;

  void dispose() => WidgetsBinding.instance.removeObserver(this);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResume();
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        onPause();
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }
}
