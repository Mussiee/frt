import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/design_constants.dart';
import '../../../../shared/widgets/avatar_widget.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../../shared/widgets/section_badge.dart';
import '../../bloc/event_requests_bloc.dart';
import '../../bloc/event_requests_event.dart';
import '../../bloc/event_requests_state.dart';
import '../../data/mock_event_requests.dart';

class EventRequestDetailScreen extends StatelessWidget {
  final String id;
  const EventRequestDetailScreen({super.key, required this.id});

  static StatusType _statusType(String s) {
    switch (s) {
      case 'approved': return StatusType.confirmed;
      case 'rejected': return StatusType.cancelled;
      case 'reviewing': return StatusType.reviewing;
      case 'incoming': return StatusType.incoming;
      case 'priority': return StatusType.priority;
      default: return StatusType.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventRequestsBloc, EventRequestsState>(
      builder: (context, state) {
        final request = mockEventRequests.firstWhere((e) => e.id == id, orElse: () => mockEventRequests.first);
        final status = context.read<EventRequestsBloc>().getStatus(request);
        final r = request;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.canPop() ? context.pop() : context.go('/event-requests'),
                      child: const Icon(Icons.arrow_back, color: FocusColors.accent),
                    ),
                    const SizedBox(width: 12),
                    Text('REQUEST DETAIL', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 24),

                // Requester info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: cardDecoration(),
                  child: Row(
                    children: [
                      AvatarWidget(name: r.name, size: 56),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.name, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 2),
                            Text(r.subtitle, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(r.phone, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12)),
                            Text(r.email, style: GoogleFonts.inter(color: FocusColors.accent, fontSize: 12)),
                            if (r.company != null) Text(r.company!, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12)),
                          ],
                        ),
                      ),
                      StatusChip(label: status.toUpperCase(), type: _statusType(status)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Event details
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: cardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('EVENT DETAILS', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
                      const SizedBox(height: 12),
                      _infoRow(Icons.calendar_today_outlined, 'Date', '${r.requestedDate} · ${r.time}'),
                      _infoRow(Icons.groups_outlined, 'Expected Guests', '${r.expectedGuests}'),
                      if (r.eventType != null) _infoRow(Icons.celebration_outlined, 'Event Type', r.eventType!),
                      if (r.budget != null) _infoRow(Icons.attach_money, 'Budget', '\$${r.budget!.toStringAsFixed(0)}'),
                      Row(
                        children: [
                          const Icon(Icons.place_outlined, color: FocusColors.accent, size: 16),
                          const SizedBox(width: 10),
                          const SizedBox(width: 90, child: Text('Section', style: TextStyle(color: FocusColors.textSecondary, fontSize: 12))),
                          SectionBadge(section: r.section),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Status timeline
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: cardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('STATUS TIMELINE', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
                      const SizedBox(height: 12),
                      _timelineStep('Requested', true),
                      _timelineStep('Reviewing', status == 'reviewing' || status == 'approved' || status == 'rejected'),
                      _timelineStep(status == 'rejected' ? 'Rejected' : 'Approved', status == 'approved' || status == 'rejected'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Notes
                if (r.notes != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ADDITIONAL NOTES', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
                        const SizedBox(height: 8),
                        Text(r.notes!, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 13)),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),

                // Actions
                if (status != 'approved' && status != 'rejected') ...[
                  Row(
                    children: [
                      Expanded(child: _actionBtn('APPROVE REQUEST', FocusColors.success, () => context.read<EventRequestsBloc>().add(EventRequestsStatusChanged(request.id, 'approved')))),
                      const SizedBox(width: 10),
                      Expanded(child: _actionBtn('REJECT REQUEST', FocusColors.error, () => context.read<EventRequestsBloc>().add(EventRequestsStatusChanged(request.id, 'rejected')))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: FocusColors.border)),
                        alignment: Alignment.center,
                        child: Text('REQUEST MORE INFO', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: FocusColors.accent, size: 16),
          const SizedBox(width: 10),
          SizedBox(width: 90, child: Text(label, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12))),
          Expanded(child: Text(value, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _timelineStep(String label, bool completed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 20, height: 20,
            decoration: BoxDecoration(
              color: completed ? FocusColors.accent : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: completed ? FocusColors.accent : FocusColors.border, width: 2),
            ),
            child: completed ? const Icon(Icons.check, color: Colors.black, size: 12) : null,
          ),
          const SizedBox(width: 12),
          Text(label, style: GoogleFonts.inter(color: completed ? FocusColors.textPrimary : FocusColors.textSecondary, fontSize: 13, fontWeight: completed ? FontWeight.w600 : FontWeight.w400)),
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
        child: Text(label, style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
      ),
    );
  }
}
