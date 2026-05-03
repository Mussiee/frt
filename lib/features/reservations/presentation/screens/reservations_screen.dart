import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/design_constants.dart';
import '../../../../shared/widgets/avatar_widget.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../../shared/widgets/section_badge.dart';
import '../../../../shared/widgets/search_bar_widget.dart';
import '../../../../shared/widgets/pagination_widget.dart';
import '../../bloc/reservations_bloc.dart';
import '../../bloc/reservations_event.dart';
import '../../bloc/reservations_state.dart';
import '../../data/mock_reservations.dart';

const _filters = ['ALL', 'PENDING', 'CONFIRMED', 'CHECKED IN', 'COMPLETED', 'NO SHOW', 'GUESTLIST', 'ASSIGNED'];

StatusType _statusType(String status) {
  switch (status) {
    case 'confirmed': return StatusType.confirmed;
    case 'pending': return StatusType.pending;
    case 'checked_in': return StatusType.arrived;
    case 'completed': return StatusType.completed;
    case 'no_show': return StatusType.noShow;
    default: return StatusType.pending;
  }
}

class ReservationsScreen extends StatelessWidget {
  const ReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationsBloc, ReservationsState>(
      builder: (context, state) {
        if (state is! ReservationsLoadSuccess) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = state.filtered;
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text('RESERVATIONS', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SearchBarWidget(hint: 'Search reservations...', onChanged: (v) => context.read<ReservationsBloc>().add(ReservationsSearchChanged(v))),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 34,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final f = _filters[i];
                    final active = f == state.filter;
                    return GestureDetector(
                      onTap: () => context.read<ReservationsBloc>().add(ReservationsFilterChanged(f)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: active ? FocusColors.accent : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: active ? null : Border.all(color: FocusColors.border),
                        ),
                        alignment: Alignment.center,
                        child: Text(f, style: GoogleFonts.inter(color: active ? Colors.black : FocusColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: items.isEmpty
                    ? Center(child: Text('No reservations found', style: GoogleFonts.inter(color: FocusColors.textSecondary)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: items.length,
                        itemBuilder: (_, i) {
                          final r = items[i];
                          final bloc = context.read<ReservationsBloc>();
                          final currentStatus = bloc.getStatus(r);
                          return _ReservationRow(
                            reservation: r,
                            statusType: _statusType(currentStatus),
                            onTap: () => context.go('/reservations/${r.id}'),
                          );
                        },
                      ),
              ),
              PaginationWidget(
                currentPage: state.page,
                totalPages: state.totalPages,
                onPageChanged: (p) => context.read<ReservationsBloc>().add(ReservationsPageChanged(p)),
                summary: 'SHOWING ${items.length} RESERVATIONS',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReservationRow extends StatelessWidget {
  final MockReservation reservation;
  final StatusType statusType;
  final VoidCallback onTap;

  const _ReservationRow({required this.reservation, required this.statusType, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: FocusColors.elevated,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: FocusColors.border, width: 0.5))),
        child: Row(
          children: [
            AvatarWidget(name: reservation.customerName, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reservation.customerName, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('${reservation.date} · ${reservation.time}', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 11)),
                      const SizedBox(width: 8),
                      Text('${reservation.partySize} guests', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      SectionBadge(section: reservation.section),
                      const SizedBox(width: 8),
                      StatusChip(label: reservation.status.replaceAll('_', ' '), type: statusType),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: FocusColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
