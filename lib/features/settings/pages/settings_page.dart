import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_icons.dart';
import '../../../core/widgets/app_list_group.dart';
import '../../../core/widgets/app_toggle.dart';
import '../../../core/widgets/content_width.dart';
import '../widgets/profile_card.dart';

/// Tela de ajustes.
///
/// Fase 1: maquete estática, fiel ao design — inclui "Plano Pro",
/// "Notificações", "Tema escuro", "Estilo/Idioma das respostas" e
/// "Privacidade e dados", que **não existem** no backend. A Fase 6 corta tudo
/// isso e deixa só perfil / citar fontes / sair (decisão Q2).
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = true;
  bool _citeSources = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return ContentWidth(
      child: Column(
        children: [
          const AppHeader(title: 'Ajustes'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              children: [
                const ProfileCard(
                  initials: 'MB',
                  name: 'Marina Barros',
                  email: 'marina.barros@gmail.com',
                  badge: 'Plano Pro',
                ),
                const SizedBox(height: 18),
                AppListGroup(
                  title: 'Preferências',
                  children: [
                    AppListRow(
                      icon: AppIcons.notifications,
                      label: 'Notificações',
                      trailing: AppToggle(
                        value: _notifications,
                        semanticLabel: 'Alternar notificações',
                        onChanged: (value) =>
                            setState(() => _notifications = value),
                      ),
                    ),
                    AppListRow(
                      icon: AppIcons.document,
                      label: 'Citar fontes nas respostas',
                      trailing: AppToggle(
                        value: _citeSources,
                        semanticLabel: 'Alternar citação de fontes',
                        onChanged: (value) =>
                            setState(() => _citeSources = value),
                      ),
                    ),
                    AppListRow(
                      icon: AppIcons.darkMode,
                      label: 'Tema escuro',
                      trailing: AppToggle(
                        value: _darkMode,
                        semanticLabel: 'Alternar tema escuro',
                        onChanged: (value) => setState(() => _darkMode = value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const AppListGroup(
                  title: 'Inteligência',
                  children: [
                    AppListRow(
                      icon: Icons.auto_awesome_outlined,
                      label: 'Estilo das respostas',
                      value: 'Objetivo',
                      showChevron: true,
                    ),
                    AppListRow(
                      icon: AppIcons.language,
                      label: 'Idioma das respostas',
                      value: 'Português',
                      showChevron: true,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                AppListGroup(
                  title: 'Conta',
                  children: [
                    const AppListRow(
                      icon: AppIcons.lock,
                      label: 'Privacidade e dados',
                      showChevron: true,
                    ),
                    AppListRow(
                      icon: AppIcons.logout,
                      label: 'Sair da conta',
                      destructive: true,
                      // Fase 2: só navega. Limpar tokens entra na Fase 9.
                      onTap: () => context.go(Routes.login),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // Atalho de desenvolvimento — sai antes do release.
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
}
