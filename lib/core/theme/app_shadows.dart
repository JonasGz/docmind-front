import 'package:flutter/material.dart';

/// Sombras derivadas do blue-900, sempre discretas.
abstract final class AppShadows {
  /// Cards e bolhas do bot: `0 1px 3px rgba(13,40,66,.05)`.
  static const card = [
    BoxShadow(color: Color(0x0D0D2842), offset: Offset(0, 1), blurRadius: 3),
  ];

  /// Knob dos toggles: `0 1px 3px rgba(13,40,66,.3)`.
  static const toggleKnob = [
    BoxShadow(color: Color(0x4D0D2842), offset: Offset(0, 1), blurRadius: 3),
  ];

  /// Sheet do login: `0 -10px 26px rgba(13,40,66,.18)`.
  static const sheet = [
    BoxShadow(color: Color(0x2E0D2842), offset: Offset(0, -10), blurRadius: 26),
  ];
}
