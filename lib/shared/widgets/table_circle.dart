import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design_constants.dart';

enum TableStatus { free, reserved, occupied }

class TableCircle extends StatelessWidget {
  final String label;
  final TableStatus status;
  final double size;
  final bool isSelected;
  final VoidCallback? onTap;

  const TableCircle({
    super.key,
    required this.label,
    required this.status,
    this.size = 52,
    this.isSelected = false,
    this.onTap,
  });

  Color get _color {
    switch (status) {
      case TableStatus.free:
        return FocusColors.success;
      case TableStatus.reserved:
        return FocusColors.accent;
      case TableStatus.occupied:
        return FocusColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? FocusColors.accent : _color,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: FocusColors.accent.withValues(alpha: 0.4), blurRadius: 12, spreadRadius: 2)]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: FocusColors.textPrimary,
            fontSize: size * 0.26,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
