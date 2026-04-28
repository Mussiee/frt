import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design_constants.dart';

class SectionBadge extends StatelessWidget {
  final String section;

  const SectionBadge({super.key, required this.section});

  Color get _color {
    final s = section.toUpperCase();
    if (s.contains('VAULT')) return FocusSections.theVault;
    if (s.contains('TERRACE')) return FocusSections.theTerrace;
    if (s.contains('VIP') || s.contains('LOUNGE')) return FocusSections.vipLounge;
    if (s.contains('SKY')) return FocusSections.skyLounge;
    return FocusSections.mainFloor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
      ),
      child: Text(
        section.toUpperCase(),
        style: GoogleFonts.inter(
          color: _color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
