import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../models/source.dart';

/// Detalhe de uma fonte citada: o trecho recuperado e a similaridade.
///
/// O score é exibido porque em matéria jurídica a diferença entre uma
/// citação forte e uma marginal muda o peso do que se afirma. Escondê-lo
/// deixaria o usuário sem como calibrar a confiança na resposta.
Future<void> showSourceDetail(BuildContext context, Source source) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.sheet),
      ),
    ),
    builder: (context) => _SourceDetailSheet(source: source),
  );
}

class _SourceDetailSheet extends StatelessWidget {
  const _SourceDetailSheet({required this.source});

  final Source source;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.xl,
          AppSpacing.xl,
          AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('FONTE CITADA', style: AppTypography.kicker),
            const SizedBox(height: AppSpacing.md),
            Text(source.documentTitle, style: AppTypography.sectionTitle),
            const SizedBox(height: AppSpacing.xs),
            // Wrap, não Row: com título longo e rótulo de relevância a linha
            // não cabe em telas estreitas.
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.xs,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('Página ${source.page}', style: AppTypography.meta),
                _RelevanceLabel(score: source.score),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.screenBackground,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: const Border(
                  left: BorderSide(color: AppColors.gold500, width: 3),
                ),
              ),
              child: SelectableText(source.excerpt, style: AppTypography.body),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.push(
                    '${Routes.documents}/viewer/${source.documentId}'
                    '?page=${source.page}',
                  );
                },
                child: const Text('Abrir no documento'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Traduz o score em algo interpretável, mantendo o número visível.
class _RelevanceLabel extends StatelessWidget {
  const _RelevanceLabel({required this.score});

  final double score;

  @override
  Widget build(BuildContext context) {
    // O backend descarta abaixo de 0,50 (SIMILARITY_THRESHOLD), então tudo
    // que chega aqui já passou do corte.
    final (label, color) = switch (score) {
      >= 0.80 => ('alta correspondência', AppColors.success),
      >= 0.65 => ('correspondência média', AppColors.gold500),
      _ => ('correspondência parcial', AppColors.gray600),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '$label · ${(score * 100).round()}%',
          style: AppTypography.meta.copyWith(color: color),
        ),
      ],
    );
  }
}
