import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_header.dart';
import '../providers/documents_providers.dart';

class DocumentViewerPage extends ConsumerStatefulWidget {
  const DocumentViewerPage({
    super.key,
    required this.documentId,
    this.initialPage,
  });

  final String documentId;
  final int? initialPage;

  @override
  ConsumerState<DocumentViewerPage> createState() => _DocumentViewerPageState();
}

class _DocumentViewerPageState extends ConsumerState<DocumentViewerPage> {
  final _controller = PdfViewerController();

  @override
  Widget build(BuildContext context) {
    final document = ref.watch(documentByIdProvider(widget.documentId));
    final url = ref.watch(documentDownloadUrlProvider(widget.documentId));

    return Scaffold(
      backgroundColor: AppColors.blue900,
      body: Column(
        children: [
          AppHeader(
            title: document.value?.displayName ?? 'Documento',
            subtitle: widget.initialPage == null
                ? null
                : 'página ${widget.initialPage}',
            action: IconButton(
              icon: const Icon(Icons.close, color: AppColors.blue900),
              tooltip: 'Fechar',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: switch (url) {
              AsyncData(:final value) => _Viewer(
                url: value,
                controller: _controller,
                initialPage: widget.initialPage,
              ),
              AsyncError() => const _ViewerMessage(
                'Não foi possível abrir este documento.',
              ),
              _ => const Center(
                child: CircularProgressIndicator(color: AppColors.gold500),
              ),
            },
          ),
        ],
      ),
    );
  }
}

class _Viewer extends StatelessWidget {
  const _Viewer({
    required this.url,
    required this.controller,
    this.initialPage,
  });

  final String url;
  final PdfViewerController controller;
  final int? initialPage;

  @override
  Widget build(BuildContext context) {
    if (AppConfig.useMocks) {
      return _ViewerMessage(
        'Pré-visualização indisponível no modo sem servidor.'
        '${initialPage == null ? '' : '\nA citação está na página $initialPage.'}',
      );
    }

    return PdfViewer.uri(
      Uri.parse(url),
      controller: controller,
      initialPageNumber: initialPage ?? 1,
      params: const PdfViewerParams(
        backgroundColor: AppColors.blue900,
        margin: AppSpacing.sm,
      ),
    );
  }
}

class _ViewerMessage extends StatelessWidget {
  const _ViewerMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTypography.body.copyWith(
            color: AppColors.white.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
