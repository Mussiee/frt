import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/design_constants.dart';
import '../../cubit/notifications_cubit.dart';

IconData _typeIcon(String type) {
  switch (type) {
    case 'reservation': return Icons.calendar_today_outlined;
    case 'payment': return Icons.payment_outlined;
    case 'event': return Icons.event_note_outlined;
    case 'checkin': return Icons.how_to_reg_outlined;
    case 'table': return Icons.table_bar_outlined;
    case 'promoter': return Icons.people_outline;
    case 'system': return Icons.settings_outlined;
    default: return Icons.notifications_outlined;
  }
}

Color _typeColor(String type) {
  switch (type) {
    case 'reservation': return FocusColors.accent;
    case 'payment': return FocusColors.success;
    case 'event': return FocusColors.info;
    case 'checkin': return FocusColors.success;
    case 'table': return FocusColors.accent;
    case 'promoter': return FocusColors.purple;
    case 'system': return FocusColors.textSecondary;
    default: return FocusColors.textSecondary;
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final notifications = state.notifications;
        final unreadCount = notifications.where((n) => !n.isRead).length;

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    Text('NOTIFICATIONS', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800)),
                    const SizedBox(width: 10),
                    if (unreadCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: FocusColors.accent, borderRadius: BorderRadius.circular(10)),
                        child: Text('$unreadCount', style: GoogleFonts.inter(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => context.read<NotificationsCubit>().markAllRead(),
                      child: Text('MARK ALL READ', style: GoogleFonts.inter(color: FocusColors.accent, fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: notifications.length,
                  itemBuilder: (_, i) {
                    final n = notifications[i];
                    final isRead = n.isRead;
                    return InkWell(
                      onTap: () => context.read<NotificationsCubit>().markAsRead(n.id),
                      splashColor: FocusColors.elevated,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: FocusColors.border, width: 0.5))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: _typeColor(n.type).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Icon(_typeIcon(n.type), color: _typeColor(n.type), size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(n.title, style: GoogleFonts.inter(
                                    color: isRead ? FocusColors.textSecondary : FocusColors.textPrimary,
                                    fontSize: 14,
                                    fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                                  )),
                                  const SizedBox(height: 2),
                                  Text(n.body, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text(n.time, style: GoogleFonts.inter(color: FocusColors.textSecondary.withValues(alpha: 0.6), fontSize: 10)),
                                ],
                              ),
                            ),
                            if (!isRead)
                              Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.only(top: 6),
                                decoration: const BoxDecoration(color: FocusColors.accent, shape: BoxShape.circle),
                              ),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, color: FocusColors.textSecondary, size: 18),
                              color: FocusColors.elevated,
                              itemBuilder: (_) => [
                                PopupMenuItem(value: 'read', child: Text(isRead ? 'Mark Unread' : 'Mark Read', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 13))),
                                PopupMenuItem(value: 'delete', child: Text('Delete', style: GoogleFonts.inter(color: FocusColors.error, fontSize: 13))),
                              ],
                              onSelected: (v) {
                                if (v == 'read') context.read<NotificationsCubit>().markAsRead(n.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
