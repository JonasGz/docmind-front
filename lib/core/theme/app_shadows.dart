import 'package:flutter/material.dart';

abstract final class AppShadows {
  static const card = [
    BoxShadow(color: Color(0x0D0D2842), offset: Offset(0, 1), blurRadius: 3),
  ];

  static const toggleKnob = [
    BoxShadow(color: Color(0x4D0D2842), offset: Offset(0, 1), blurRadius: 3),
  ];

  static const sheet = [
    BoxShadow(color: Color(0x2E0D2842), offset: Offset(0, -10), blurRadius: 26),
  ];
}
