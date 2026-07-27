import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_icon_button.dart';
import '../../../core/widgets/app_icons.dart';
import '../../../core/widgets/content_width.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_composer.dart';

/// Tela de chat.
///
/// Fase 1: maquete estática com as mensagens literais do design. O estado real
/// e o envio entram na Fase 5.
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentWidth(
      child: Column(
        children: [
          AppHeader(
            title: 'Chat',
            subtitle: '4 documentos no contexto',
            action: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIconButton.outline(
                  icon: Icons.history,
                  semanticLabel: 'Conversas',
                  size: 38,
                  onPressed: () => context.push(Routes.conversations),
                ),
                const SizedBox(width: AppSpacing.sm),
                AppIconButton.primary(
                  icon: AppIcons.add,
                  semanticLabel: 'Nova conversa',
                  size: 38,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const Expanded(child: _MessageList()),
          const ChatComposer(),
        ],
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  const _MessageList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: const [
        BotBubble(
          text:
              'Olá, Marina! Seus documentos já foram processados. '
              'Pergunte qualquer coisa sobre eles.',
        ),
        SizedBox(height: AppSpacing.lg),
        UserBubble(text: 'Qual o prazo de vigência do contrato de locação?'),
        SizedBox(height: AppSpacing.lg),
        BotBubble(
          text:
              'O contrato tem vigência de 30 meses, com início em 1º de '
              'março de 2026 e término em 31 de agosto de 2028. Há cláusula '
              'de renovação automática mediante aviso prévio de 90 dias.',
          sources: ['Contrato_Locacao.pdf · pág. 4'],
        ),
      ],
    );
  }
}

/// Indicador "digitando": 3 dots com stagger de .18s, ciclo de 1.1s.
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // prefers-reduced-motion: sem animação, dots estáticos.
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Row(
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
                      // 0–40%: sobe e acende; 40–80%: volta; 80–100%: parado.
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

/// Quadrado 30×30 blue-900 com o sparkle dourado, à esquerda das mensagens
/// do bot.
class BotAvatar extends StatelessWidget {
  const BotAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: AppColors.blue900,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: const Center(
        child: SparkleIcon(size: 15, color: AppColors.gold500),
      ),
    );
  }
}

/// Texto de apoio da tela vazia — não existe no design, mas evita uma tela
/// em branco antes da primeira mensagem.
class ChatEmptyHint extends StatelessWidget {
  const ChatEmptyHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Pergunte algo sobre seus documentos.',
        style: AppTypography.body.copyWith(color: AppColors.gray400),
      ),
    );
  }
}
