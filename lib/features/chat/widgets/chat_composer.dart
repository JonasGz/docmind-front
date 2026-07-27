import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_icon_button.dart';
import '../../../core/widgets/app_icons.dart';

/// Barra de composição do chat: anexar (outline), campo pill e enviar (gold).
class ChatComposer extends StatelessWidget {
  const ChatComposer({super.key, this.controller, this.onSend, this.onAttach});

  final TextEditingController? controller;
  final VoidCallback? onSend;
  final VoidCallback? onAttach;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.gray200)),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.md,
        AppSpacing.screenPadding,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          AppIconButton.outline(
            icon: AppIcons.attach,
            semanticLabel: 'Anexar documento',
            onPressed: onAttach ?? () {},
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              style: AppTypography.body.copyWith(color: AppColors.blue900),
              decoration: const InputDecoration(
                hintText: 'Pergunte sobre seus documentos…',
                isDense: true,
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: onSend == null ? null : (_) => onSend!(),
            ),
          ),
          const SizedBox(width: 10),
          AppIconButton.gold(
            icon: AppIcons.send,
            semanticLabel: 'Enviar',
            onPressed: onSend ?? () {},
          ),
        ],
      ),
    );
  }
}
