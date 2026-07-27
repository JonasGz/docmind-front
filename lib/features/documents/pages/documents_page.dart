import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/content_width.dart';
import '../models/document.dart';
import '../viewmodels/documents_viewmodel.dart';
import '../widgets/document_card.dart';
import '../widgets/documents_search_field.dart';
import '../widgets/upload_button.dart';

class DocumentsPage extends ConsumerStatefulWidget {
  const DocumentsPage({super.key});

  @override
  ConsumerState<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends ConsumerState<DocumentsPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final documents = ref.watch(documentsViewModelProvider);

    return ContentWidth(
      child: Column(
        children: [
          AppHeader(
            title: 'Documentos',
            subtitle: switch (documents) {
              AsyncData(:final value) => _countLabel(value.length),
              _ => null,
            },
            bottom: DocumentsSearchField(
              onChanged: (query) => setState(() => _query = query),
            ),
          ),
          Expanded(
            child: switch (documents) {
              AsyncData(:final value) => _DocumentList(
                documents: _filter(value),
                hasAny: value.isNotEmpty,
                onUpload: _pickAndUpload,
                onDelete: _confirmDelete,
              ),
              AsyncError(:final error) => _ErrorState(
                error: error,
                onRetry: () =>
                    ref.read(documentsViewModelProvider.notifier).refresh(),
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

  String _countLabel(int count) =>
      count == 1 ? '1 documento' : '$count documentos';

  List<Document> _filter(List<Document> documents) {
    if (_query.trim().isEmpty) return documents;

    final query = _query.toLowerCase().trim();
    return documents.where((document) {
      final identifiers = document.identifiers?.join(' ') ?? '';
      return '${document.displayName} ${document.filename} $identifiers'
          .toLowerCase()
          .contains(query);
    }).toList();
  }

  Future<void> _pickAndUpload() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,

      allowedExtensions: const ['pdf'],
      withData: true,
    );

    final file = result?.files.singleOrNull;
    if (file == null || file.bytes == null) return;

    try {
      await ref
          .read(documentsViewModelProvider.notifier)
          .upload(filename: file.name, bytes: file.bytes!);
    } on Object catch (error) {
      if (!mounted) return;
      _showError('Não foi possível enviar o documento.', error);
    }
  }

  Future<void> _confirmDelete(Document document) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover documento?'),
        content: Text(
          '"${document.displayName}" sai da biblioteca e deixa de ser '
          'consultado nas respostas do chat.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(documentsViewModelProvider.notifier).delete(document.id);
    } on Object catch (error) {
      if (!mounted) return;
      _showError('Não foi possível remover o documento.', error);
    }
  }

  void _showError(String message, Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.danger),
    );
  }
}

class _DocumentList extends StatelessWidget {
  const _DocumentList({
    required this.documents,
    required this.hasAny,
    required this.onUpload,
    required this.onDelete,
  });

  final List<Document> documents;

  final bool hasAny;

  final Future<void> Function() onUpload;
  final Future<void> Function(Document) onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: documents.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        if (index == 0) return UploadButton(onPressed: onUpload);

        final document = documents[index - 1];
        return DocumentCard(
          document: document,
          onTap: document.status.isReady
              ? () => context.push('${Routes.documents}/viewer/${document.id}')
              : null,
          onDelete: () => onDelete(document),
        );
      },
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Não foi possível carregar seus documentos.',
              textAlign: TextAlign.center,
              style: AppTypography.body,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Tentar de novo'),
            ),
          ],
        ),
      ),
    );
  }
}
