import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/user.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_icons.dart';
import '../../../core/widgets/app_list_group.dart';
import '../../../core/widgets/app_toggle.dart';
import '../../../core/widgets/content_width.dart';
import '../../auth/providers/auth_providers.dart';
import '../providers/preferences_provider.dart';
import '../widgets/profile_card.dart';

/// Ajustes.
///
/// Enxuto em relação ao desenho: "Plano Pro", notificações, tema escuro,
/// estilo e idioma das respostas, e "Privacidade e dados" não existem no
/// backend e foram removidos. Interface que promete o que o sistema não faz
/// é dívida que ninguém remove.
///
/// Sobrou o que tem efeito real: perfil, citação de fontes e sair da conta.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final citeSources = ref.watch(citeSourcesPreferenceProvider).value ?? true;

    return ContentWidth(
      child: Column(
        children: [
          const AppHeader(title: 'Ajustes'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              children: [
                _ProfileSection(user: user),
                const SizedBox(height: 18),
                AppListGroup(
                  title: 'Preferências',
                  children: [
                    AppListRow(
                      icon: AppIcons.document,
                      label: 'Citar fontes nas respostas',
                      trailing: AppToggle(
                        value: citeSources,
                        semanticLabel: 'Alternar citação de fontes',
                        onChanged: (value) => ref
                            .read(citeSourcesPreferenceProvider.notifier)
                            .toggle(value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                AppListGroup(
                  title: 'Conta',
                  children: [
                    AppListRow(
                      icon: AppIcons.logout,
                      label: 'Sair da conta',
                      destructive: true,
                      onTap: () => _confirmSignOut(context, ref),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                AppListGroup(
                  title: 'Desenvolvimento',
                  children: [
                    AppListRow(
                      icon: Icons.palette_outlined,
                      label: 'Galeria de componentes',
                      showChevron: true,
                      onTap: () => context.push(Routes.gallery),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'Doc Mind v1.0.0',
                  textAlign: TextAlign.center,
                  style: AppTypography.meta.copyWith(color: AppColors.gray400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da conta?'),
        content: const Text(
          'Seus documentos continuam salvos e estarão aqui quando você voltar.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await ref.read(authViewModelProvider.notifier).signOut();
    if (context.mounted) context.go(Routes.login);
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    if (user case final user?) {
      // Sem badge: o backend não tem planos.
      return ProfileCard(
        initials: user.initials,
        name: user.displayName,
        email: user.email,
      );
    }

    return const ProfileCard(initials: '—', name: 'Carregando…', email: '');
  }
}
