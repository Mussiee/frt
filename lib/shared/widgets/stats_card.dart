import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design_constants.dart';

class StatsCard extends StatelessWidget {
  final String label;
  final String value;
  final String? trend;
  final bool trendPositive;

  const StatsCard({
    super.key,
    required this.label,
    required this.value,
    this.trend,
    this.trendPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.inter(
              color: FocusColors.textSecondary,
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.inter(
              color: FocusColors.accent,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),

          if (trend != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  trendPositive ? Icons.trending_up : Icons.trending_down,
                  size: 14,
                  color: trendPositive ? FocusColors.success : FocusColors.error,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    trend!,
                    style: GoogleFonts.inter(
                      color: trendPositive ? FocusColors.success : FocusColors.error,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
