import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/design_constants.dart';
import '../../../../shared/widgets/avatar_widget.dart';
import '../../../../shared/widgets/stats_card.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../data/mock_promoter_stats.dart';

StatusType _statusType(String s) {
  switch (s) {
    case 'arrived': return StatusType.arrived;
    case 'confirmed': return StatusType.confirmed;
    case 'no_show': return StatusType.noShow;
    default: return StatusType.pending;
  }
}

class MyStatsScreen extends StatelessWidget {
  const MyStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                AvatarWidget(name: MockPromoterSelfStats.name, size: 56),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(MockPromoterSelfStats.name, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: FocusColors.accent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                      child: Text(MockPromoterSelfStats.badge, style: GoogleFonts.inter(color: FocusColors.accent, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                    ),
                    const SizedBox(height: 4),
                    Text(MockPromoterSelfStats.joinDate, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 11)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Referral link
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: cardDecoration(),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('REFERRAL LINK', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 1)),
                        const SizedBox(height: 4),
                        Text('focus.club/r/${MockPromoterSelfStats.referralCode}', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 13)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Link copied!'), backgroundColor: FocusColors.accent)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(color: FocusColors.accent, borderRadius: BorderRadius.circular(6)),
                      child: Row(
                        children: [
                          const Icon(Icons.copy, color: Colors.black, size: 14),
                          const SizedBox(width: 4),
                          Text('COPY LINK', style: GoogleFonts.inter(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Stats
            Row(
              children: [
                const Expanded(child: StatsCard(label: 'Total Bookings', value: '342', trend: '+12% from last month')),
                const SizedBox(width: 10),
                const Expanded(child: StatsCard(label: 'Paid Bookings', value: '289', trend: '84.5% conversion rate')),
              ],
            ),
            const SizedBox(height: 10),
            const StatsCard(label: 'Revenue Generated', value: '\$14,240', trend: '\$2,455 this month'),
            const SizedBox(height: 24),

            // Recent reservations
            Text('Recent Reservations', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...MockPromoterSelfStats.recentReferrals.map((r) => Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: FocusColors.border, width: 0.5))),
              child: Row(
                children: [
                  AvatarWidget(name: r.name, size: 32),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.name, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                        Text(r.partyInfo, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10)),
                      ],
                    ),
                  ),
                  StatusChip(label: r.status.replaceAll('_', ' '), type: _statusType(r.status)),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('\$${r.amount.toStringAsFixed(2)}', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
                      Text(r.paymentLabel, style: GoogleFonts.inter(color: FocusColors.accent, fontSize: 9, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
