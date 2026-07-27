import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_icons.dart';
import '../providers/auth_providers.dart';
import '../services/google_sign_in_service.dart';

/// Tela de login.
///
/// Fase 1: maquete estática com os textos literais do design. Os botões não
/// fazem nada ainda — o Google Sign-In entra na Fase 9 e o "Entrar com e-mail"
/// abre um sheet "em breve" (decisão Q4).
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.blue900,
      body: Column(
        children: [
          Expanded(child: _Hero()),
          _SignInSheet(),
        ],
      ),
    );
  }
}

/// Metade superior: gradiente 165° de blue-900 a blue-700, ícone do app,
/// wordmark "DocMind", régua dourada e o subtítulo.
class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          // 165° em CSS ≈ do topo levemente à esquerda para a base à direita.
          begin: Alignment(-0.26, -1),
          end: Alignment(0.26, 1),
          colors: [AppColors.blue900, AppColors.blue700],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      // Em altura normal o bloco fica centralizado; em janelas baixas
      // (paisagem, tela dividida) ele rola em vez de estourar.
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Squircle com borda dourada translúcida.
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(AppRadius.appIcon),
                    border: Border.all(
                      color: AppColors.gold500.withValues(alpha: 0.45),
                    ),
                  ),
                  child: const Center(
                    child: DocumentCheckIcon(
                      size: 38,
                      color: AppColors.gold500,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                // "Doc" em 600 branco + "Mind" em 300 dourado.
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Doc'),
                      TextSpan(
                        text: 'Mind',
                        style: AppTypography.display.copyWith(
                          fontWeight: FontWeight.w300,
                          color: AppColors.gold300,
                        ),
                      ),
                    ],
                  ),
                  style: AppTypography.display,
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  width: 44,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.gold500,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 18),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 270),
                  child: Text(
                    'Seus documentos, respondendo às suas perguntas. '
                    'Envie, processe e converse.',
                    textAlign: TextAlign.center,
                    style: AppTypography.body.copyWith(
                      height: 1.65,
                      color: AppColors.white.withValues(alpha: 0.78),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Sheet branco com radius 22 no topo, sombra ascendente e os dois botões.
class _SignInSheet extends ConsumerStatefulWidget {
  const _SignInSheet();

  @override
  ConsumerState<_SignInSheet> createState() => _SignInSheetState();
}

class _SignInSheetState extends ConsumerState<_SignInSheet> {
  bool _signingIn = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _signingIn = true);

    try {
      final idToken = await ref.read(googleSignInServiceProvider).signIn();
      // Cancelado pelo usuário: volta ao estado inicial, sem erro.
      if (idToken == null) return;

      await ref.read(authViewModelProvider.notifier).signInWithGoogle(idToken);

      if (!mounted) return;
      final session = ref.read(authViewModelProvider);
      if (session.hasError) {
        _showSignInError();
        return;
      }
      context.go(Routes.chat);
    } on Object {
      if (mounted) _showSignInError();
    } finally {
      if (mounted) setState(() => _signingIn = false);
    }
  }

  void _showSignInError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Não foi possível entrar. Tente de novo.'),
        backgroundColor: AppColors.danger,
      ),
    );
  }

  /// O botão existe no design mas o backend só autentica via Google. Em vez
  /// de removê-lo, ele explica que ainda não está disponível (decisão Q4).
  void _showEmailComingSoon(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.sheet),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.xxl,
          AppSpacing.xl,
          AppSpacing.xxl + MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('EM BREVE', style: AppTypography.kicker),
            const SizedBox(height: AppSpacing.md),
            Text('Entrada por e-mail', style: AppTypography.sectionTitle),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Por enquanto o acesso é só pela conta Google. '
              'A entrada por e-mail e senha chega em uma próxima versão.',
              style: AppTypography.body,
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendi'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.sheet),
        ),
        boxShadow: AppShadows.sheet,
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xxl,
        AppSpacing.xl,
        40 + bottomInset,
      ),
      child: Center(
        child: ConstrainedBox(
          // Impede o conteúdo de esticar em janelas largas (skill de
          // layout responsivo).
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('BEM-VINDO', style: AppTypography.kicker),
              const SizedBox(height: AppSpacing.lg),
              Text('Entrar no Doc Mind', style: AppTypography.sectionTitle),
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                onPressed: _signingIn ? null : _signInWithGoogle,
                icon: _signingIn
                    ? const SizedBox(
                        width: 19,
                        height: 19,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.blue900,
                        ),
                      )
                    : const GoogleLogo(),
                label: Text(_signingIn ? 'Entrando…' : 'Continuar com Google'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(AppSize.signInButton),
                  textStyle: AppTypography.labelMedium.copyWith(fontSize: 15),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const _OrDivider(),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: () => _showEmailComingSoon(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Entrar com e-mail'),
              ),
              const SizedBox(height: 22),
              const _LegalText(),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'ou',
            style: AppTypography.meta.copyWith(
              fontSize: 11.5,
              color: AppColors.gray400,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

/// "Ao continuar, você concorda com os Termos de Uso e a Política de
/// Privacidade." — os dois links sublinhados em dourado.
class _LegalText extends StatelessWidget {
  const _LegalText();

  @override
  Widget build(BuildContext context) {
    final base = AppTypography.meta.copyWith(
      fontSize: 11,
      height: 1.6,
      color: AppColors.gray400,
    );
    final link = base.copyWith(
      color: AppColors.blue900,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.gold500,
    );

    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(text: 'Ao continuar, você concorda com os '),
          TextSpan(text: 'Termos de Uso', style: link),
          const TextSpan(text: ' e a '),
          TextSpan(text: 'Política de Privacidade', style: link),
          const TextSpan(text: '.'),
        ],
      ),
      textAlign: TextAlign.center,
      style: base,
    );
  }
}
