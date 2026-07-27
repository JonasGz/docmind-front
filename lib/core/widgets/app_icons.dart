import 'package:flutter/material.dart';

/// Os ícones do design são traços de 24×24 no estilo Lucide/Feather.
/// Os equivalentes `Icons.*_outlined` do Material cobrem quase todos; os que
/// não têm equivalente próximo (documento com check, sparkle) são desenhados
/// abaixo a partir do mesmo path SVG do design.
abstract final class AppIcons {
  static const chat = Icons.chat_bubble_outline;
  static const document = Icons.insert_drive_file_outlined;
  static const settings = Icons.settings_outlined;
  static const search = Icons.search;
  static const upload = Icons.file_upload_outlined;
  static const add = Icons.add;
  static const send = Icons.send_outlined;
  static const attach = Icons.attach_file;
  static const chevronRight = Icons.chevron_right;
  static const notifications = Icons.notifications_none;
  static const darkMode = Icons.dark_mode_outlined;
  static const lock = Icons.lock_outline;
  static const logout = Icons.logout;
  static const language = Icons.language;
}

/// Documento com check — ícone do app no login.
/// Path: M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z
///       M14 2v6h6  M9.5 13.5l1.5 1.5 3.5-3.5
class DocumentCheckIcon extends StatelessWidget {
  const DocumentCheckIcon({super.key, required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _DocumentCheckPainter(color),
    );
  }
}

class _DocumentCheckPainter extends CustomPainter {
  const _DocumentCheckPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Corpo da folha com o canto dobrado.
    final body = Path()
      ..moveTo(14 * s, 2 * s)
      ..lineTo(6 * s, 2 * s)
      ..cubicTo(4.9 * s, 2 * s, 4 * s, 2.9 * s, 4 * s, 4 * s)
      ..lineTo(4 * s, 20 * s)
      ..cubicTo(4 * s, 21.1 * s, 4.9 * s, 22 * s, 6 * s, 22 * s)
      ..lineTo(18 * s, 22 * s)
      ..cubicTo(19.1 * s, 22 * s, 20 * s, 21.1 * s, 20 * s, 20 * s)
      ..lineTo(20 * s, 8 * s)
      ..close();
    canvas.drawPath(body, paint);

    // Dobra do canto.
    canvas.drawPath(
      Path()
        ..moveTo(14 * s, 2 * s)
        ..lineTo(14 * s, 8 * s)
        ..lineTo(20 * s, 8 * s),
      paint,
    );

    // Check.
    canvas.drawPath(
      Path()
        ..moveTo(9.5 * s, 13.5 * s)
        ..lineTo(11 * s, 15 * s)
        ..lineTo(14.5 * s, 11.5 * s),
      paint,
    );
  }

  @override
  bool shouldRepaint(_DocumentCheckPainter old) => old.color != color;
}

/// Sparkle de 4 pontas — avatar do bot no chat.
/// Path: M12 3l1.9 4.6L18.5 9l-4.6 1.9L12 15.5l-1.9-4.6L5.5 9l4.6-1.4z
class SparkleIcon extends StatelessWidget {
  const SparkleIcon({super.key, required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _SparklePainter(color),
    );
  }
}

class _SparklePainter extends CustomPainter {
  const _SparklePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(
      Path()
        ..moveTo(12 * s, 3 * s)
        ..lineTo(13.9 * s, 7.6 * s)
        ..lineTo(18.5 * s, 9 * s)
        ..lineTo(13.9 * s, 10.9 * s)
        ..lineTo(12 * s, 15.5 * s)
        ..lineTo(10.1 * s, 10.9 * s)
        ..lineTo(5.5 * s, 9 * s)
        ..lineTo(10.1 * s, 7.6 * s)
        ..close(),
      paint,
    );
  }

  @override
  bool shouldRepaint(_SparklePainter old) => old.color != color;
}

/// Logo colorido do Google, para o botão de sign-in.
class GoogleLogo extends StatelessWidget {
  const GoogleLogo({super.key, this.size = 19});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _GoogleLogoPainter());
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 48;
    final c = Offset(24 * s, 24 * s);
    final radius = 22 * s;
    final stroke = 10 * s;
    final rect = Rect.fromCircle(center: c, radius: radius - stroke / 2);

    void arc(double startDeg, double sweepDeg, Color color) {
      canvas.drawArc(
        rect,
        startDeg * 3.1415926535 / 180,
        sweepDeg * 3.1415926535 / 180,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke,
      );
    }

    arc(-150, 120, const Color(0xFFEA4335)); // vermelho, topo
    arc(-30, 90, const Color(0xFF4285F4)); // azul, direita
    arc(60, 90, const Color(0xFF34A853)); // verde, base
    arc(150, 60, const Color(0xFFFBBC05)); // amarelo, esquerda

    // Barra horizontal do "G".
    canvas.drawRect(
      Rect.fromLTRB(24 * s, 19 * s, 41 * s, 29 * s),
      Paint()..color = const Color(0xFF4285F4),
    );
  }

  @override
  bool shouldRepaint(_GoogleLogoPainter oldDelegate) => false;
}
