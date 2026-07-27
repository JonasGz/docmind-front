import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/document.dart';
import '../providers/documents_providers.dart';

part 'documents_viewmodel.g.dart';

/// Lista de documentos do usuário, com polling enquanto houver documento em
/// processamento.
///
/// É global (`keepAlive`), e não atrelado à tela: o subtítulo do chat
/// ("N documentos no contexto") consome o mesmo estado, e um upload iniciado
/// na aba Documentos precisa continuar sendo acompanhado depois que o usuário
/// troca de aba.
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
        // Ao voltar do segundo plano, consulta imediatamente em vez de
        // esperar o próximo ciclo.
        unawaited(refresh());
      },
      onPause: _stopPolling,
    );

    final documents = await ref.read(documentsRepositoryProvider).list();
    _syncPolling(documents);
    return documents;
  }

  /// Recarrega sem passar por estado de carregamento — usado pelo polling e
  /// pelo pull-to-refresh, onde piscar a tela seria pior que esperar.
  Future<void> refresh() async {
    try {
      final documents = await ref.read(documentsRepositoryProvider).list();
      state = AsyncData(documents);
      _syncPolling(documents);
    } on Object catch (error, stack) {
      // Uma falha isolada de polling não pode apagar a lista já exibida.
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

    // Remoção otimista: a lista responde na hora e volta atrás se falhar.
    state = AsyncData(previous.where((d) => d.id != id).toList());

    try {
      await ref.read(documentsRepositoryProvider).delete(id);
      _syncPolling(state.requireValue);
    } on Object {
      state = AsyncData(previous);
      rethrow;
    }
  }

  /// Liga o polling quando há documento pendente e desliga quando não há —
  /// sem isso o temporizador viveria para sempre consultando à toa.
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

/// Quantidade de documentos indexados — o que o chat pode citar.
@riverpod
int indexedDocumentCount(Ref ref) {
  final documents = ref.watch(documentsViewModelProvider).value;
  return documents?.where((d) => d.status.isReady).length ?? 0;
}

/// Observa segundo plano/retorno do aplicativo para pausar o polling.
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
