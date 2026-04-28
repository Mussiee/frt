import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/design_constants.dart';
import '../../../../shared/widgets/avatar_widget.dart';
import '../../../../shared/widgets/stats_card.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../../shared/widgets/pagination_widget.dart';
import '../../data/mock_promoters.dart';

class PromoterDetailScreen extends StatelessWidget {
  final String id;
  const PromoterDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final p = mockPromoters.firstWhere((p) => p.id == id, orElse: () => mockPromoters.first);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb
            Row(
              children: [
                GestureDetector(
                  onTap: () => context.canPop() ? context.pop() : context.go('/promoters'),
                  child: const Icon(Icons.arrow_back, color: FocusColors.accent),
                ),
                const SizedBox(width: 8),
                Text('PROMOTERS', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 11, letterSpacing: 0.5)),
                const Icon(Icons.chevron_right, color: FocusColors.textSecondary, size: 16),
                Text('${p.name.toUpperCase()} DETAIL', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 11, letterSpacing: 0.5)),
              ],
            ),
            const SizedBox(height: 24),

            // Header
            Row(
              children: [
                AvatarWidget(name: p.name, size: 60),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.name, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: FocusColors.accent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                            child: Text(p.badge, style: GoogleFonts.inter(color: FocusColors.accent, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.calendar_today_outlined, color: FocusColors.textSecondary, size: 12),
                          const SizedBox(width: 4),
                          Text(p.joinDate, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('REFERRAL LINK', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 1)),
                      const SizedBox(height: 4),
                      Text('nightops.com/ref/mrusso_77', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 13)),
                    ],
                  ),
                  const Spacer(),
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
                Expanded(child: StatsCard(label: 'Total Bookings', value: '${p.totalBookings}', trend: p.trendText)),
                const SizedBox(width: 10),
                Expanded(child: StatsCard(label: 'Paid Bookings', value: '${p.paidBookings}', trend: '${p.conversionRate}% conversion rate')),
              ],
            ),
            const SizedBox(height: 10),
            StatsCard(label: 'Revenue Generated', value: '\$${p.revenue.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}', trend: '${p.revenueThisPeriod} this month'),
            const SizedBox(height: 24),

            // Recent reservations
            Row(
              children: [
                Text('Recent Reservations', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                const Spacer(),
                Text('FILTER:', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10)),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: FocusColors.border)),
                  child: Text('ALL BOOKINGS', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 10, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Column headers
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Text('CUSTOMER', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 1))),
                  Expanded(flex: 2, child: Text('STATUS', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 1))),
                  Expanded(flex: 2, child: Text('PAYMENT', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 1))),
                  Expanded(flex: 2, child: Text('DATE', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 1))),
                  const SizedBox(width: 24),
                ],
              ),
            ),
            Container(height: 0.5, color: FocusColors.border),

            if (p.recentBookings.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Center(child: Text('No recent bookings', style: GoogleFonts.inter(color: FocusColors.textSecondary))),
              )
            else
              ...p.recentBookings.map((b) => Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: FocusColors.border, width: 0.5))),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          AvatarWidget(name: b.customerName, size: 30),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(b.customerName, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
                                Text(b.partyInfo, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 9)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(flex: 2, child: StatusChip(label: b.status.replaceAll('_', ' '), type: _bookingStatusType(b.status))),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('\$${b.amount.toStringAsFixed(2)}', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
                          Text(b.paymentLabel, style: GoogleFonts.inter(color: FocusColors.accent, fontSize: 9, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Expanded(flex: 2, child: Text(b.date, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 11))),
                    const Icon(Icons.more_vert, color: FocusColors.textSecondary, size: 18),
                  ],
                ),
              )),

            PaginationWidget(
              currentPage: 1,
              totalPages: 3,
              onPageChanged: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}

StatusType _bookingStatusType(String s) {
  switch (s) {
    case 'arrived': return StatusType.arrived;
    case 'confirmed': return StatusType.confirmed;
    case 'no_show': return StatusType.noShow;
    default: return StatusType.pending;
  }
}
