import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design_constants.dart';

enum StatusType { confirmed, pending, cancelled, completed, noShow, arrived, incoming, priority, reviewing, occupied, free, reserved, paid, deposit, unpaid, forfeited }

class StatusChip extends StatelessWidget {
  final String label;
  final StatusType type;

  const StatusChip({super.key, required this.label, required this.type});

  Color get _color {
    switch (type) {
      case StatusType.confirmed:
      case StatusType.arrived:
      case StatusType.paid:
      case StatusType.completed:
      case StatusType.free:
        return FocusColors.success;
      case StatusType.pending:
      case StatusType.reviewing:
      case StatusType.reserved:
        return FocusColors.accent;
      case StatusType.cancelled:
      case StatusType.noShow:
      case StatusType.occupied:
      case StatusType.forfeited:
        return FocusColors.error;
      case StatusType.incoming:
        return FocusColors.info;
      case StatusType.priority:
      case StatusType.deposit:
        return FocusColors.orange;
      case StatusType.unpaid:
        return FocusColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          color: _color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
