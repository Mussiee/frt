import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/design_constants.dart';
import '../../../../shared/widgets/avatar_widget.dart';
import '../../../../shared/widgets/stats_card.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../data/mock_customers.dart';

class CustomerDetailScreen extends StatelessWidget {
  final String id;
  const CustomerDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final c = mockCustomers.firstWhere((c) => c.id == id, orElse: () => mockCustomers.first);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back
            Row(
              children: [
                GestureDetector(
                  onTap: () => context.canPop() ? context.pop() : context.go('/crm'),
                  child: const Icon(Icons.arrow_back, color: FocusColors.accent),
                ),
                const SizedBox(width: 12),
                Text('CUSTOMER PROFILE', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 24),

            // Header card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: cardDecoration(),
              child: Row(
                children: [
                  AvatarWidget(name: c.name, size: 64),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.name, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.phone_outlined, color: FocusColors.textSecondary, size: 14),
                            const SizedBox(width: 4),
                            Text(c.phone, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12)),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.email_outlined, color: FocusColors.textSecondary, size: 14),
                            const SizedBox(width: 4),
                            Flexible(child: Text(c.email, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12))),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: FocusColors.accent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                          child: Text(c.tier, style: GoogleFonts.inter(color: FocusColors.accent, fontSize: 10, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: FocusColors.border)),
                      alignment: Alignment.center,
                      child: Text('EDIT PROFILE', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(color: FocusColors.accent, borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      child: Text('CREATE BOOKING', style: GoogleFonts.inter(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Stats
            Row(
              children: [
                Expanded(child: StatsCard(label: 'Total Visits', value: '${c.totalVisits}', trend: 'Lifetime')),
                const SizedBox(width: 10),
                Expanded(child: StatsCard(label: 'Total Spend', value: '\$${c.totalSpend.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}', trend: 'USD')),
              ],
            ),
            const SizedBox(height: 10),

            // Tier progress
            Container(
              padding: const EdgeInsets.all(16),
              decoration: cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('NEXT TIER PROGRESS', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 1)),
                      const Spacer(),
                      Text('${(c.tierProgress * 100).round()}%', style: GoogleFonts.inter(color: FocusColors.accent, fontSize: 13, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(c.nextTier, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: c.tierProgress,
                      minHeight: 8,
                      backgroundColor: FocusColors.border,
                      valueColor: const AlwaysStoppedAnimation(FocusColors.accent),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Reservation history
            Row(
              children: [
                Text('Reservation History', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                const Spacer(),
                Text('VIEW ALL', style: GoogleFonts.inter(color: FocusColors.accent, fontSize: 11, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 12),
            if (c.visitHistory.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(child: Text('No visit history', style: GoogleFonts.inter(color: FocusColors.textSecondary))),
              )
            else
              ...c.visitHistory.map((v) => Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: FocusColors.border, width: 0.5))),
                child: Row(
                  children: [
                    SizedBox(width: 70, child: Text(v.date, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 11))),
                    const SizedBox(width: 8),
                    StatusChip(
                      label: v.status.replaceAll('_', ' '),
                      type: v.status == 'completed' ? StatusType.completed : StatusType.noShow,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(v.promoter, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12))),
                    Text('\$${v.payment.toStringAsFixed(0)}', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    const Icon(Icons.more_vert, color: FocusColors.textSecondary, size: 18),
                  ],
                ),
              )),
            const SizedBox(height: 24),

            // Promoter links
            if (c.promoterLinks.isNotEmpty) ...[
              Text('Booked via Promoters', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              ...c.promoterLinks.map((p) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: cardDecoration(),
                child: Row(
                  children: [
                    AvatarWidget(name: p.name, size: 40, backgroundColor: p.hasPhoto ? FocusColors.accent : FocusColors.textSecondary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.name, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                          Text('${p.bookings} BOOKINGS TOTAL', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10, letterSpacing: 0.5)),
                          if (p.role.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: FocusColors.accent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(3)),
                                  child: Text(p.role, style: GoogleFonts.inter(color: FocusColors.accent, fontSize: 9, fontWeight: FontWeight.w600)),
                                ),
                                if (p.lastActivity.isNotEmpty) ...[
                                  const SizedBox(width: 8),
                                  Text(p.lastActivity, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10)),
                                ],
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (p.role.isNotEmpty) const Icon(Icons.chevron_right, color: FocusColors.accent, size: 20),
                  ],
                ),
              )),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: FocusColors.border)),
                    alignment: Alignment.center,
                    child: Text('ASSIGN NEW PROMOTER', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
