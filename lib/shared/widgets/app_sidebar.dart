import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../cubit/role_cubit.dart';
import '../design_constants.dart';
import '../mock_session.dart';
import 'sidebar_item.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  static const Map<UserRole, List<SidebarItem>> _roleItems = {
    UserRole.owner: [
      SidebarItem(icon: Icons.dashboard_outlined, label: 'Dashboard', route: '/dashboard'),
      SidebarItem(icon: Icons.calendar_today_outlined, label: 'Reservations', route: '/reservations'),
      SidebarItem(icon: Icons.people_outline, label: 'Promoters', route: '/promoters'),
      SidebarItem(icon: Icons.contacts_outlined, label: 'CRM', route: '/crm'),
      SidebarItem(icon: Icons.event_note_outlined, label: 'Event Requests', route: '/event-requests'),
      SidebarItem(icon: Icons.settings_outlined, label: 'Settings', route: '/settings'),
    ],
    UserRole.host: [
      SidebarItem(icon: Icons.dashboard_outlined, label: 'Dashboard', route: '/dashboard'),
      SidebarItem(icon: Icons.calendar_today_outlined, label: 'Reservations', route: '/reservations'),
      SidebarItem(icon: Icons.table_bar_outlined, label: 'Tables', route: '/tables'),
      SidebarItem(icon: Icons.settings_outlined, label: 'Settings', route: '/settings'),
    ],
    UserRole.staff: [
      SidebarItem(icon: Icons.table_bar_outlined, label: 'My Tables', route: '/my-tables'),
      SidebarItem(icon: Icons.settings_outlined, label: 'Settings', route: '/settings'),
    ],
    UserRole.security: [
      SidebarItem(icon: Icons.qr_code_scanner_outlined, label: 'QR Scanner', route: '/scanner'),
      SidebarItem(icon: Icons.checklist_outlined, label: 'Checked-In', route: '/checked-in'),
      SidebarItem(icon: Icons.settings_outlined, label: 'Settings', route: '/settings'),
    ],
    UserRole.promoter: [
      SidebarItem(icon: Icons.bar_chart_outlined, label: 'My Stats', route: '/my-stats'),
      SidebarItem(icon: Icons.link_outlined, label: 'My Link', route: '/my-link'),
      SidebarItem(icon: Icons.settings_outlined, label: 'Settings', route: '/settings'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleCubit, RoleState>(
      builder: (context, roleState) {
        final items = _roleItems[roleState.role] ?? [];
        final currentPath = GoRouterState.of(context).uri.path;

        return Drawer(
          backgroundColor: FocusColors.surface,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: FocusColors.accent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          MockSession.instance.userInitials,
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              MockSession.instance.userName,
                              style: GoogleFonts.inter(
                                color: FocusColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: FocusColors.accent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                roleState.roleLabel,
                                style: GoogleFonts.inter(
                                  color: FocusColors.accent,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                  child: Text(
                    'VENUE OPS',
                    style: GoogleFonts.inter(
                      color: FocusColors.accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'NIGHT OPERATIONS',
                    style: TextStyle(
                      color: FocusColors.textSecondary,
                      fontSize: 9,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(height: 1, color: FocusColors.border),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isActive = currentPath == item.route;
                      return _SidebarTile(
                        item: item,
                        isActive: isActive,
                        onTap: () {
                          context.go(item.route);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                ),
                Container(height: 1, color: FocusColors.border),
                ListTile(
                  leading: const Icon(Icons.logout, color: FocusColors.textSecondary, size: 20),
                  title: Text(
                    'LOGOUT',
                    style: GoogleFonts.inter(
                      color: FocusColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.go('/splash');
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SidebarTile extends StatelessWidget {
  final SidebarItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarTile({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: isActive ? FocusColors.accent : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          splashColor: FocusColors.elevated,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 20,
                  color: isActive ? Colors.black : FocusColors.textSecondary,
                ),
                const SizedBox(width: 12),
                Text(
                  item.label.toUpperCase(),
                  style: GoogleFonts.inter(
                    color: isActive ? Colors.black : FocusColors.textSecondary,
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
