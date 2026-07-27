import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_icon_button.dart';
import '../../../core/widgets/app_icons.dart';

/// Barra de composição: anexar, campo pill e enviar.
class ChatComposer extends StatefulWidget {
  const ChatComposer({
    super.key,
    required this.controller,
    required this.onSend,
    this.enabled = true,
  });

  final TextEditingController controller;
  final VoidCallback onSend;

  /// Falso enquanto a resposta anterior não chegou — o envio é bloqueante.
  final bool enabled;

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  @override
  void initState() {
    super.initState();
    // Reconstrói para habilitar/desabilitar o botão conforme o texto.
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final canSend = widget.enabled && widget.controller.text.trim().isNotEmpty;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.gray200)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.md,
        AppSpacing.screenPadding,
        AppSpacing.sm + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Row(
        children: [
          AppIconButton.outline(
            icon: AppIcons.attach,
            semanticLabel: 'Anexar documento',
            // O upload vive na aba Documentos; aqui o botão leva até lá em
            // vez de duplicar o fluxo.
            onPressed: widget.enabled
                ? () => context.go(Routes.documents)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: widget.controller,
              enabled: widget.enabled,
              style: AppTypography.body.copyWith(color: AppColors.blue900),
              decoration: InputDecoration(
                hintText: widget.enabled
                    ? 'Pergunte sobre seus documentos…'
                    : 'Aguardando a resposta…',
                isDense: true,
              ),
              textInputAction: TextInputAction.send,
              minLines: 1,
              maxLines: 4,
              onSubmitted: (_) {
                if (canSend) widget.onSend();
              },
            ),
          ),
          const SizedBox(width: 10),
          AppIconButton.gold(
            icon: AppIcons.send,
            semanticLabel: 'Enviar',
            onPressed: canSend ? widget.onSend : null,
          ),
        ],
      ),
    );
  }
}
