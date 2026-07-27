import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/router/routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../core/widgets/app_card.dart';
import '../core/widgets/app_chip.dart';
import '../core/widgets/app_header.dart';
import '../core/widgets/app_icon_button.dart';
import '../core/widgets/app_icons.dart';
import '../core/widgets/app_list_group.dart';
import '../core/widgets/app_tab_bar.dart';
import '../core/widgets/app_toggle.dart';
import '../features/chat/pages/chat_page.dart';
import '../features/chat/widgets/chat_bubble.dart';
import '../features/documents/widgets/document_card.dart';
import '../features/documents/widgets/upload_button.dart';
import '../features/settings/widgets/profile_card.dart';

/// Galeria de componentes e atalho para as 4 telas.
/// Rota `/dev/gallery` — ferramenta de revisão, fora do app final.
class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppHeader(
            title: 'Galeria',
            subtitle: 'Componentes e telas — Fase 1',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              children: const [
                _Section('Telas', [_ScreenLinks()]),
                _Section('Cores', [_ColorSwatches()]),
                _Section('Tipografia', [_TypeSpecimens()]),
                _Section('Botões', [_ButtonSamples()]),
                _Section('Botões de ícone', [_IconButtonSamples()]),
                _Section('Chips', [_ChipSamples()]),
                _Section('Toggle', [_ToggleSample()]),
                _Section('Card', [_CardSamples()]),
                _Section('Lista agrupada', [_ListGroupSample()]),
                _Section('Documento', [_DocumentSamples()]),
                _Section('Perfil', [_ProfileSample()]),
                _Section('Chat', [_ChatSamples()]),
                _Section('Tab bar', [_TabBarSample()]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title, this.children);

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title.toUpperCase(), style: AppTypography.kicker),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }
}

class _ScreenLinks extends StatelessWidget {
  const _ScreenLinks();

  @override
  Widget build(BuildContext context) {
    // As telas internas dependem do shell para ter a tab bar, então aqui
    // navegamos por rota em vez de instanciar a página direto.
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        AppChip.accent(label: 'Login', onTap: () => context.push(Routes.login)),
        AppChip.accent(label: 'Chat', onTap: () => context.go(Routes.chat)),
        AppChip.accent(
          label: 'Documentos',
          onTap: () => context.go(Routes.documents),
        ),
        AppChip.accent(
          label: 'Ajustes',
          onTap: () => context.go(Routes.settings),
        ),
      ],
    );
  }
}

class _ColorSwatches extends StatelessWidget {
  const _ColorSwatches();

  static const _swatches = [
    ('blue-900', AppColors.blue900),
    ('blue-700', AppColors.blue700),
    ('gold-500', AppColors.gold500),
    ('gold-300', AppColors.gold300),
    ('gray-100', AppColors.gray100),
    ('gray-200', AppColors.gray200),
    ('gray-400', AppColors.gray400),
    ('gray-600', AppColors.gray600),
    ('success', AppColors.success),
    ('danger', AppColors.danger),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final (name, color) in _swatches)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 44,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: AppColors.gray200),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(name, style: AppTypography.tabLabel),
            ],
          ),
      ],
    );
  }
}

class _TypeSpecimens extends StatelessWidget {
  const _TypeSpecimens();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Display 30/600',
          style: AppTypography.display.copyWith(color: AppColors.blue900),
        ),
        Text('Título de tela 23/600', style: AppTypography.screenTitle),
        Text('Título de seção 21/600', style: AppTypography.sectionTitle),
        Text('Header bar 17/600', style: AppTypography.headerBar),
        Text('Título de card 15/500', style: AppTypography.cardTitle),
        Text('Corpo 14/300 — o rato roeu a roupa', style: AppTypography.body),
        Text('Label 14/400', style: AppTypography.label),
        Text('Metadado 11/300', style: AppTypography.meta),
        Text('KICKER 11/500', style: AppTypography.kicker),
      ],
    );
  }
}

class _ButtonSamples extends StatelessWidget {
  const _ButtonSamples();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(onPressed: () {}, child: const Text('Primário')),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const GoogleLogo(),
          label: const Text('Continuar com Google'),
        ),
        const SizedBox(height: AppSpacing.sm),
        ElevatedButton(onPressed: null, child: const Text('Desabilitado')),
        const SizedBox(height: AppSpacing.sm),
        UploadButton(onPressed: () {}),
      ],
    );
  }
}

class _IconButtonSamples extends StatelessWidget {
  const _IconButtonSamples();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppIconButton.primary(
          icon: AppIcons.add,
          semanticLabel: 'Primário',
          onPressed: () {},
        ),
        const SizedBox(width: AppSpacing.md),
        AppIconButton.gold(
          icon: AppIcons.send,
          semanticLabel: 'Dourado',
          onPressed: () {},
        ),
        const SizedBox(width: AppSpacing.md),
        AppIconButton.outline(
          icon: AppIcons.attach,
          semanticLabel: 'Outline',
          onPressed: () {},
        ),
        const SizedBox(width: AppSpacing.md),
        AppIconButton.primary(
          icon: AppIcons.add,
          semanticLabel: 'Desabilitado',
          onPressed: null,
        ),
      ],
    );
  }
}

class _ChipSamples extends StatelessWidget {
  const _ChipSamples();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        const AppChip.accent(
          label: 'Contrato_Locacao.pdf · pág. 4',
          icon: AppIcons.document,
        ),
        const AppChip.neutral(label: 'Neutro'),
        const AppChip.status(label: 'Pronto', color: AppColors.success),
        const AppChip.status(label: 'Falhou', color: AppColors.danger),
      ],
    );
  }
}

class _ToggleSample extends StatefulWidget {
  const _ToggleSample();

  @override
  State<_ToggleSample> createState() => _ToggleSampleState();
}

class _ToggleSampleState extends State<_ToggleSample> {
  bool _on = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppToggle(
          value: _on,
          semanticLabel: 'Exemplo',
          onChanged: (value) => setState(() => _on = value),
        ),
        const SizedBox(width: AppSpacing.lg),
        const AppToggle(value: false, onChanged: null),
      ],
    );
  }
}

class _CardSamples extends StatelessWidget {
  const _CardSamples();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard(child: Text('Card estático', style: AppTypography.label)),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          onTap: () {},
          child: Text(
            'Card tocável — borda dourada no press',
            style: AppTypography.label,
          ),
        ),
      ],
    );
  }
}

class _ListGroupSample extends StatelessWidget {
  const _ListGroupSample();

  @override
  Widget build(BuildContext context) {
    return const AppListGroup(
      title: 'Exemplo',
      children: [
        AppListRow(
          icon: AppIcons.lock,
          label: 'Com chevron',
          showChevron: true,
        ),
        AppListRow(
          icon: AppIcons.language,
          label: 'Com valor',
          value: 'Português',
          showChevron: true,
        ),
        AppListRow(
          icon: AppIcons.logout,
          label: 'Destrutivo',
          destructive: true,
        ),
      ],
    );
  }
}

class _DocumentSamples extends StatelessWidget {
  const _DocumentSamples();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        DocumentCard(
          fileType: 'PDF',
          name: 'Contrato_Locacao.pdf',
          meta: '12 páginas · há 2 dias',
          status: DocumentCardStatus.ready,
        ),
        SizedBox(height: AppSpacing.md),
        DocumentCard(
          fileType: 'PDF',
          name: 'Processando_com_percentual.pdf',
          meta: '6 páginas · agora',
          status: DocumentCardStatus.processing,
          progress: 0.64,
        ),
        SizedBox(height: AppSpacing.md),
        DocumentCard(
          fileType: 'PDF',
          name: 'Processando_indeterminado.pdf',
          meta: 'enviado agora',
          status: DocumentCardStatus.processing,
        ),
        SizedBox(height: AppSpacing.md),
        DocumentCard(
          fileType: 'PDF',
          name: 'Falhou.pdf',
          meta: 'erro ao processar',
          status: DocumentCardStatus.failed,
        ),
      ],
    );
  }
}

class _ProfileSample extends StatelessWidget {
  const _ProfileSample();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ProfileCard(
          initials: 'MB',
          name: 'Marina Barros',
          email: 'marina.barros@gmail.com',
          badge: 'Plano Pro',
        ),
        SizedBox(height: AppSpacing.md),
        ProfileCard(
          initials: 'JC',
          name: 'Sem badge',
          email: 'jonas@exemplo.com',
        ),
      ],
    );
  }
}

class _ChatSamples extends StatelessWidget {
  const _ChatSamples();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        BotBubble(text: 'Bolha do bot, sem fonte citada.'),
        SizedBox(height: AppSpacing.md),
        BotBubble(
          text: 'Bolha do bot com uma fonte.',
          sources: ['Contrato_Locacao.pdf · pág. 4'],
        ),
        SizedBox(height: AppSpacing.md),
        UserBubble(text: 'Bolha do usuário.'),
        SizedBox(height: AppSpacing.md),
        Align(alignment: Alignment.centerLeft, child: TypingIndicator()),
      ],
    );
  }
}

class _TabBarSample extends StatefulWidget {
  const _TabBarSample();

  @override
  State<_TabBarSample> createState() => _TabBarSampleState();
}

class _TabBarSampleState extends State<_TabBarSample> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return AppTabBar(
      currentIndex: _index,
      onTap: (index) => setState(() => _index = index),
    );
  }
}
