import 'package:flutter/material.dart';

/// Centraliza e limita a largura do conteúdo em janelas largas.
///
/// O design é de coluna única de telefone; sem isso, em desktop ou tablet o
/// texto atravessaria a tela inteira e os cards ficariam com proporções
/// estranhas. Baseado na largura disponível, não no tipo de aparelho — a skill
/// de layout responsivo é explícita quanto a isso.
class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child, this.maxWidth = 600});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // A altura é imposta explicitamente: o shell entrega constraints
        // frouxas na vertical e, sem isto, a Column da tela colapsa para zero
        // e todo o conteúdo desaparece.
        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: constraints.maxWidth.clamp(0.0, maxWidth),
            height: constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : null,
            child: child,
          ),
        );
      },
    );
  }
}
