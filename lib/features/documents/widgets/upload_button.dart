import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_icons.dart';

/// Botão de upload com borda tracejada dourada. O Flutter não tem borda
/// tracejada nativa, então ela é pintada.
class UploadButton extends StatefulWidget {
  const UploadButton({super.key, required this.onPressed});

  final FutureOr<void> Function() onPressed;

  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  bool _highlighted = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: MouseRegion(
        onEnter: (_) => setState(() => _highlighted = true),
        onExit: (_) => setState(() => _highlighted = false),
        child: GestureDetector(
          onTap: widget.onPressed,
          onTapDown: (_) => setState(() => _highlighted = true),
          onTapUp: (_) => setState(() => _highlighted = false),
          onTapCancel: () => setState(() => _highlighted = false),
          child: CustomPaint(
            painter: _DashedBorderPainter(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 54,
              decoration: BoxDecoration(
                color: _highlighted
                    ? AppColors.goldTint
                    : AppColors.goldTintSoft,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    AppIcons.upload,
                    size: 18,
                    color: AppColors.gold500,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    'Enviar documento',
                    style: AppTypography.labelMedium.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gold500
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(AppRadius.md),
        ),
      );

    // Traço de 6px com 4px de intervalo, ao longo do perímetro arredondado.
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = (distance + 6).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance = end + 4;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) => false;
}
