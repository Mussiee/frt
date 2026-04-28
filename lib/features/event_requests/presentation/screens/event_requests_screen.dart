import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/design_constants.dart';
import '../../../../shared/widgets/avatar_widget.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../../shared/widgets/section_badge.dart';
import '../../../../shared/widgets/pagination_widget.dart';
import '../../bloc/event_requests_bloc.dart';
import '../../bloc/event_requests_event.dart';
import '../../bloc/event_requests_state.dart';
import '../../data/mock_event_requests.dart';

class EventRequestsScreen extends StatelessWidget {
  const EventRequestsScreen({super.key});

  static StatusType _statusType(String s) {
    switch (s) {
      case 'reviewing': return StatusType.reviewing;
      case 'incoming': return StatusType.incoming;
      case 'priority': return StatusType.priority;
      case 'pending': return StatusType.pending;
      case 'approved': return StatusType.confirmed;
      case 'rejected': return StatusType.cancelled;
      default: return StatusType.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventRequestsBloc, EventRequestsState>(
      builder: (context, state) {
        if (state is! EventRequestsLoadSuccess) {
          return const Center(child: CircularProgressIndicator());
        }

        final bloc = context.read<EventRequestsBloc>();
        final requests = state.requests;
        final pending = requests.where((e) => !['approved', 'rejected'].contains(bloc.getStatus(e))).length;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + stats
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('EVENT REQUESTS', style: GoogleFonts.inter(color: FocusColors.accent, fontSize: 24, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text('Manage incoming VIP and corporate booking applications', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        _statBadge('PENDING', '$pending'),
                        const SizedBox(width: 8),
                        _statBadge('TODAY', '08'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Priority spotlight
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: cardDecoration(),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('PRIORITY SECTION', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 1)),
                            const SizedBox(height: 4),
                            Text('The Vault VIP', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text('DEMAND LEVEL  ', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 9, letterSpacing: 0.5)),
                                Text('HIGH CAPACITY', style: GoogleFonts.inter(color: FocusColors.success, fontSize: 10, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 80, height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(colors: [FocusColors.purple, FocusColors.accent]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Queue header
                Row(
                  children: [
                    Text('LIVE REQUEST QUEUE', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                    const Spacer(),
                    _ghostBtn('EXPORT CSV', Icons.download_outlined),
                    const SizedBox(width: 8),
                    _ghostBtn('FILTERS', Icons.filter_list),
                  ],
                ),
                const SizedBox(height: 12),

                // Request list
                ...requests.map((e) {
                  final status = bloc.getStatus(e);
                  return _RequestRow(
                    request: e,
                    status: status,
                    statusType: _statusType(status),
                    onApprove: () => context.read<EventRequestsBloc>().add(EventRequestsStatusChanged(e.id, 'approved')),
                    onReject: () => context.read<EventRequestsBloc>().add(EventRequestsStatusChanged(e.id, 'rejected')),
                    onTap: () => context.go('/event-requests/${e.id}'),
                  );
                }),

                PaginationWidget(
                  currentPage: 1,
                  totalPages: 3,
                  onPageChanged: (_) {},
                  summary: 'Showing 1-${requests.length} of 24 active requests',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statBadge(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: FocusColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: FocusColors.border),
      ),
      child: Column(
        children: [
          Text(label, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
          const SizedBox(height: 2),
          Text(value, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _ghostBtn(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: FocusColors.border)),
      child: Row(
        children: [
          Icon(icon, color: FocusColors.textSecondary, size: 14),
          const SizedBox(width: 4),
          Text(label, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _RequestRow extends StatelessWidget {
  final MockEventRequest request;
  final String status;
  final StatusType statusType;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onTap;

  const _RequestRow({required this.request, required this.status, required this.statusType, required this.onApprove, required this.onReject, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: FocusColors.elevated,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: FocusColors.border, width: 0.5))),
        child: Column(
          children: [
            Row(
              children: [
                AvatarWidget(name: request.name, size: 38),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(request.name, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                      Text(request.subtitle, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 11)),
                    ],
                  ),
                ),
                StatusChip(label: status.toUpperCase(), type: statusType),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 50),
                Text(request.phone, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 11)),
                const Spacer(),
                Text(request.requestedDate, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 11)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 50),
                SectionBadge(section: request.section),
                const Spacer(),
                if (status != 'approved' && status != 'rejected') ...[
                  _smallBtn('APPROVE', FocusColors.success, onApprove),
                  const SizedBox(width: 6),
                  _smallBtn('REJECT', FocusColors.error, onReject),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallBtn(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        child: Text(label, style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
