import 'package:flutter/material.dart';

abstract class FocusColors {
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF141414);
  static const Color elevated = Color(0xFF1C1C1C);
  static const Color accent = Color(0xFFF0A500);
  static const Color accentLight = Color(0xFFF5C518);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A0A0);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF0A500);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color orange = Color(0xFFF97316);
  static const Color border = Color(0xFF2A2A2A);
  static const Color teal = Color(0xFF14B8A6);
  static const Color purple = Color(0xFF8B5CF6);
}

abstract class FocusSections {
  static const Color mainFloor = FocusColors.accent;
  static const Color theVault = FocusColors.orange;
  static const Color theTerrace = FocusColors.teal;
  static const Color vipLounge = FocusColors.purple;
  static const Color skyLounge = FocusColors.info;
}

BoxDecoration cardDecoration({Color? color}) => BoxDecoration(
      color: color ?? FocusColors.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: FocusColors.border),
    );

BoxDecoration elevatedCardDecoration() => BoxDecoration(
      color: FocusColors.elevated,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: FocusColors.border),
    );
