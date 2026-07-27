import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'bot_avatar.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  static const _stages = [
    (after: Duration.zero, label: null),
    (after: Duration(seconds: 3), label: 'Procurando nos documentos…'),
    (after: Duration(seconds: 7), label: 'Reunindo os trechos encontrados…'),
    (after: Duration(seconds: 12), label: 'Redigindo a resposta…'),
  ];

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  late final DateTime _startedAt = DateTime.now();
  Timer? _stageTimer;

  @override
  void initState() {
    super.initState();

    _stageTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _stageTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  String? get _stageLabel {
    final elapsed = DateTime.now().difference(_startedAt);
    String? label;
    for (final stage in _stages) {
      if (elapsed >= stage.after) label = stage.label;
    }
    return label;
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BotAvatar(),
            const SizedBox(width: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.gray200),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(AppRadius.md),
                  bottomLeft: Radius.circular(AppRadius.md),
                  bottomRight: Radius.circular(AppRadius.md),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < 3; i++) ...[
                    if (i > 0) const SizedBox(width: AppSpacing.xs),
                    if (reduceMotion)
                      const _Dot(opacity: 0.6, offsetY: 0)
                    else
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) {
                          final t = (_controller.value - i * 0.18) % 1.0;
                          final lift = t < 0.4
                              ? t / 0.4
                              : t < 0.8
                              ? 1 - (t - 0.4) / 0.4
                              : 0.0;
                          return _Dot(
                            opacity: 0.25 + 0.75 * lift,
                            offsetY: -3 * lift,
                          );
                        },
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
        if (_stageLabel case final label?)
          Padding(
            padding: const EdgeInsets.only(left: 42, top: AppSpacing.sm),
            child: Text(
              label,
              style: AppTypography.meta.copyWith(color: AppColors.gray400),
            ),
          ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.opacity, required this.offsetY});

  final double opacity;
  final double offsetY;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, offsetY),
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: AppColors.blue900,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
