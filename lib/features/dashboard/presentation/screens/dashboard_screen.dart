import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/design_constants.dart';
import '../../../../shared/widgets/avatar_widget.dart';
import '../../../../shared/widgets/stats_card.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../../shared/widgets/section_badge.dart';
import '../../../../shared/mock_session.dart';
import '../../../reservations/data/mock_reservations.dart';

StatusType _statusType(String s) {
  switch (s) {
    case 'confirmed': return StatusType.confirmed;
    case 'pending': return StatusType.pending;
    case 'checked_in': return StatusType.arrived;
    case 'completed': return StatusType.completed;
    case 'no_show': return StatusType.noShow;
    default: return StatusType.pending;
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Text('Good Evening,', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 14)),
            Text(MockSession.instance.userName, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 20),

            // Stats grid — 2x2, IntrinsicHeight equalises card heights
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: StatsCard(label: 'Pending Requests', value: '24', trend: '+3 today', trendPositive: true)),
                  const SizedBox(width: 10),
                  Expanded(child: StatsCard(label: 'Wk Revenue ▲', value: '08')),
                ],
              ),
            ),
            const SizedBox(height: 10),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: StatsCard(label: 'Active Promoters', value: '142', trend: '6 online', trendPositive: true)),
                  const SizedBox(width: 10),
                  Expanded(child: StatsCard(label: "Tonight's Revenue", value: '\$4,820', trend: 'Peak hour', trendPositive: true)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Live Request Queue
            Row(
              children: [
                Text('LIVE REQUEST QUEUE', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                const Spacer(),
                GestureDetector(
                  onTap: () => context.go('/reservations'),
                  child: Text('VIEW ALL', style: GoogleFonts.inter(color: FocusColors.accent, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ...mockReservations.take(6).map((r) => InkWell(
              onTap: () => context.go('/reservations/${r.id}'),
              splashColor: FocusColors.elevated,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: FocusColors.border, width: 0.5))),
                child: Row(
                  children: [
                    AvatarWidget(name: r.customerName, size: 36),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.customerName, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text('${r.date} · ${r.time}', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 11)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SectionBadge(section: r.section),
                        const SizedBox(height: 4),
                        StatusChip(label: r.status.replaceAll('_', ' '), type: _statusType(r.status)),
                      ],
                    ),
                    if (r.status == 'pending') ...[
                      const SizedBox(width: 8),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: FocusColors.success, borderRadius: BorderRadius.circular(4)),
                              child: Text('APPROVE', style: GoogleFonts.inter(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: FocusColors.error, borderRadius: BorderRadius.circular(4)),
                              child: Text('REJECT', style: GoogleFonts.inter(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
