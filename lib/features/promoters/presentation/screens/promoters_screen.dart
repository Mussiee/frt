import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/design_constants.dart';
import '../../../../shared/widgets/avatar_widget.dart';
import '../../../../shared/widgets/stats_card.dart';
import '../../../../shared/widgets/pagination_widget.dart';
import '../../bloc/promoters_bloc.dart';
import '../../bloc/promoters_event.dart';
import '../../bloc/promoters_state.dart';
import '../../data/mock_promoters.dart';

class PromotersScreen extends StatelessWidget {
  const PromotersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PromotersBloc, PromotersState>(
      builder: (context, state) {
        if (state is! PromotersLoadSuccess) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PROMOTERS', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text('Manage referral networks and performance tracking.', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(color: FocusColors.accent, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const Icon(Icons.add, color: Colors.black, size: 16),
                            const SizedBox(width: 4),
                            Text('CREATE', style: GoogleFonts.inter(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Stats row
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.8,
                  children: const [
                    StatsCard(label: 'Active Promoters', value: '142'),
                    StatsCard(label: 'Total Revenue', value: '\$248.5K'),
                    StatsCard(label: 'Total Bookings', value: '1,829'),
                    StatsCard(label: 'Top Performer', value: 'V. RUSSO'),
                  ],
                ),
                const SizedBox(height: 20),

                // Promoters table
                ...state.filtered.map((p) => _PromoterRow(
                  promoter: p,
                  onTap: () => context.go('/promoters/${p.id}'),
                )),

                PaginationWidget(
                  currentPage: state.page,
                  totalPages: state.totalPages,
                  onPageChanged: (p) => context.read<PromotersBloc>().add(PromotersPageChanged(p)),
                  summary: 'SHOWING ${state.filtered.length} OF 142 PROMOTERS',
                ),

                // Bottom cards
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _infoCard('PROMOTER ANALYTICS', 'Download detailed performance reports in CSV/PDF.', Icons.download_outlined)),
                    const SizedBox(width: 10),
                    Expanded(child: _infoCard('PAYOUT SETTINGS', 'Manage commission rates and payment automated flows.', Icons.settings_outlined)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _infoCard(String title, String sub, IconData icon) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: cardDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700))),
            Icon(icon, color: FocusColors.accent, size: 20),
          ],
        ),
        const SizedBox(height: 6),
        Text(sub, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 11)),
      ],
    ),
  );
}

class _PromoterRow extends StatelessWidget {
  final MockPromoter promoter;
  final VoidCallback onTap;

  const _PromoterRow({required this.promoter, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: FocusColors.elevated,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: FocusColors.border, width: 0.5))),
        child: Row(
          children: [
            AvatarWidget(name: promoter.name, size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(promoter.name.toUpperCase(), style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('${promoter.totalBookings} bookings', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 11)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: FocusColors.success.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                        child: Text('${promoter.paidBookings}', style: GoogleFonts.inter(color: FocusColors.success, fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                      const Spacer(),
                      Text('\$${promoter.revenue.toStringAsFixed(2)}', style: GoogleFonts.inter(color: FocusColors.accent, fontSize: 13, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.more_vert, color: FocusColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
