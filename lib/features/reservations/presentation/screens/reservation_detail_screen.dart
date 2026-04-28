import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/design_constants.dart';
import '../../../../shared/widgets/avatar_widget.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../../shared/widgets/section_badge.dart';
import '../../bloc/reservations_bloc.dart';
import '../../bloc/reservations_event.dart';
import '../../bloc/reservations_state.dart';
import '../../data/mock_reservations.dart';

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

Widget _infoRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Icon(icon, color: FocusColors.accent, size: 16),
        const SizedBox(width: 10),
        SizedBox(
          width: 90,
          child: Text(label, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12)),
        ),
        Expanded(child: Text(value, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500))),
      ],
    ),
  );
}

Widget _actionBtn(String label, Color color, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 48,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      alignment: Alignment.center,
      child: Text(label, style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
    ),
  );
}

class ReservationDetailScreen extends StatelessWidget {
  final String id;
  const ReservationDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final reservation = mockReservations.firstWhere((r) => r.id == id, orElse: () => mockReservations.first);

    return BlocBuilder<ReservationsBloc, ReservationsState>(
      builder: (context, state) {
        final bloc = context.read<ReservationsBloc>();
        final currentStatus = bloc.getStatus(reservation);
        final r = reservation;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.canPop() ? context.pop() : context.go('/reservations'),
                      child: const Icon(Icons.arrow_back, color: FocusColors.accent),
                    ),
                    const SizedBox(width: 12),
                    Text('RESERVATION DETAIL', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                  ],
                ),
                const SizedBox(height: 24),

                // Guest info card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: cardDecoration(),
                  child: Row(
                    children: [
                      AvatarWidget(name: r.customerName, size: 56),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.customerName, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text(r.phone, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 13)),
                            if (r.tier != null) ...[
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: FocusColors.accent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                                child: Text(r.tier!, style: GoogleFonts.inter(color: FocusColors.accent, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                              ),
                            ],
                          ],
                        ),
                      ),
                      StatusChip(label: currentStatus.replaceAll('_', ' '), type: _statusType(currentStatus)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Booking info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: cardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('BOOKING DETAILS', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
                      const SizedBox(height: 12),
                      _infoRow(Icons.calendar_today_outlined, 'Date & Time', '${r.date} · ${r.time}'),
                      _infoRow(Icons.groups_outlined, 'Party Size', '${r.partySize} guests'),
                      _infoRow(Icons.place_outlined, 'Section', r.section),
                      if (r.tableNumber != null) _infoRow(Icons.table_bar_outlined, 'Table', r.tableNumber!),
                      if (r.amount != null) _infoRow(Icons.attach_money, 'Amount', '\$${r.amount!.toStringAsFixed(2)}'),
                      _infoRow(Icons.payment_outlined, 'Payment', r.paymentStatus.toUpperCase()),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Promoter
                if (r.promoterName != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: cardDecoration(),
                    child: Row(
                      children: [
                        const Icon(Icons.person_pin_outlined, color: FocusColors.accent, size: 20),
                        const SizedBox(width: 10),
                        Text('Referred by ', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 13)),
                        Text(r.promoterName!, style: GoogleFonts.inter(color: FocusColors.accent, fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                if (r.promoterName != null) const SizedBox(height: 16),

                // Notes
                if (r.notes != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NOTES', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
                        const SizedBox(height: 8),
                        Text(r.notes!, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 13)),
                      ],
                    ),
                  ),
                if (r.notes != null) const SizedBox(height: 16),

                // Section badge
                SectionBadge(section: r.section),
                const SizedBox(height: 24),

                // Actions
                if (currentStatus == 'pending') ...[
                  Row(
                    children: [
                      Expanded(child: _actionBtn('CONFIRM', FocusColors.success, () => context.read<ReservationsBloc>().add(ReservationStatusUpdated(r.id, 'confirmed')))),
                      const SizedBox(width: 10),
                      Expanded(child: _actionBtn('REJECT', FocusColors.error, () => context.read<ReservationsBloc>().add(ReservationStatusUpdated(r.id, 'no_show')))),
                    ],
                  ),
                ] else if (currentStatus == 'confirmed') ...[
                  Row(
                    children: [
                      Expanded(child: _actionBtn('CHECK IN', FocusColors.success, () => context.read<ReservationsBloc>().add(ReservationStatusUpdated(r.id, 'checked_in')))),
                      const SizedBox(width: 10),
                      Expanded(child: _actionBtn('NO SHOW', FocusColors.error, () => context.read<ReservationsBloc>().add(ReservationStatusUpdated(r.id, 'no_show')))),
                    ],
                  ),
                ] else if (currentStatus == 'checked_in') ...[
                  SizedBox(width: double.infinity, child: _actionBtn('COMPLETE', FocusColors.accent, () => context.read<ReservationsBloc>().add(ReservationStatusUpdated(r.id, 'completed')))),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
