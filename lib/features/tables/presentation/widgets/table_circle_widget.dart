import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/design_constants.dart';
import '../../../../shared/widgets/table_circle.dart';
import '../../data/mock_tables.dart';

class TableCircleWidget extends StatelessWidget {
  final MockTable table;
  final bool isSelected;
  final VoidCallback onTap;

  const TableCircleWidget({
    super.key,
    required this.table,
    required this.isSelected,
    required this.onTap,
  });

  static const double _tableScale = 0.72;

  Color get _statusColor {
    switch (table.status) {
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
    final isCircle =
        table.tableType == TableType.barStool ||
        table.tableType == TableType.circle ||
        table.tableType == TableType.largeCircle;

    final baseSize = 42.0 * table.sizeMultiplier * _tableScale;

    if (isCircle) {
      return _buildCircle(baseSize);
    } else {
      return _buildRect(baseSize);
    }
  }

  Widget _buildCircle(double size) {
    final fontSize = (size * 0.28).clamp(7.0, 14.0);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _statusColor.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? FocusColors.accent : _statusColor,
            width: isSelected ? 2.5 : 1.6,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: FocusColors.accent.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          table.label,
          style: GoogleFonts.inter(
            color: FocusColors.textPrimary,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildRect(double baseSize) {
    final width = baseSize * 1.35;
    final height = baseSize * 1.0;
    final fontSize = (baseSize * 0.30).clamp(7.0, 14.0);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: _statusColor.withValues(alpha: 0.20),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? FocusColors.accent : _statusColor,
            width: isSelected ? 2.5 : 1.6,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: FocusColors.accent.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          table.label,
          style: GoogleFonts.inter(
            color: FocusColors.textPrimary,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
