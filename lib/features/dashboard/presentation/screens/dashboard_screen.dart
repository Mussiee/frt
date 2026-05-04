import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/design_constants.dart';
import '../../../../shared/widgets/stats_card.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../../shared/mock_session.dart';
import '../../../tables/data/mock_tables.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final events = mockEvents.where((event) {
      final d = event.startsAt;
      final eventDay = DateTime(d.year, d.month, d.day);
      return !eventDay.isBefore(today);
    }).toList()..sort((a, b) => a.startsAt.compareTo(b.startsAt));

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Text(
              'Good Evening,',
              style: GoogleFonts.inter(
                color: FocusColors.textSecondary,
                fontSize: 14,
              ),
            ),
            Text(
              MockSession.instance.userName,
              style: GoogleFonts.inter(
                color: FocusColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),

            // Stats grid — 2x2, IntrinsicHeight equalises card heights
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: StatsCard(
                      label: 'Pending Requests',
                      value: '24',
                      trend: '+3 today',
                      trendPositive: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatsCard(label: 'Wk Revenue ▲', value: '08'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: StatsCard(
                      label: 'Active Promoters',
                      value: '142',
                      trend: '6 online',
                      trendPositive: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatsCard(
                      label: "Tonight's Revenue",
                      value: '\$4,820',
                      trend: 'Peak hour',
                      trendPositive: true,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Events
            Row(
              children: [
                Text(
                  'EVENTS',
                  style: GoogleFonts.inter(
                    color: FocusColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => context.go('/tables'),
                  child: Text(
                    'VIEW ALL',
                    style: GoogleFonts.inter(
                      color: FocusColors.accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (events.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'No live or upcoming events.',
                  style: GoogleFonts.inter(
                    color: FocusColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              )
            else
              ...events.map((event) {
                final startsAt = event.startsAt;
                final isLive =
                    startsAt.year == today.year &&
                    startsAt.month == today.month &&
                    startsAt.day == today.day;
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: FocusColors.border, width: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: FocusColors.accent.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.event,
                          color: FocusColors.accent,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.name,
                              style: GoogleFonts.inter(
                                color: FocusColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${event.date} · ${event.time}',
                              style: GoogleFonts.inter(
                                color: FocusColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      StatusChip(
                        label: isLive ? 'LIVE' : 'UPCOMING',
                        type: isLive
                            ? StatusType.confirmed
                            : StatusType.incoming,
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
