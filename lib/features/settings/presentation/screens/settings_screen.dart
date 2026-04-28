import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/cubit/role_cubit.dart';
import '../../../../shared/design_constants.dart';
import '../../../../shared/widgets/avatar_widget.dart';
import '../../../../shared/mock_session.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailUpdates = false;
  bool _smsAlerts = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SETTINGS', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 24),

            // Profile
            Container(
              padding: const EdgeInsets.all(16),
              decoration: cardDecoration(),
              child: Row(
                children: [
                  AvatarWidget(name: MockSession.instance.userName, size: 56),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(MockSession.instance.userName, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(MockSession.instance.userPhone, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 13)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: FocusColors.accent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                          child: Text(context.read<RoleCubit>().state.roleLabel, style: GoogleFonts.inter(color: FocusColors.accent, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Role Switcher
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: FocusColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: FocusColors.accent.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.developer_mode, color: FocusColors.accent, size: 18),
                      const SizedBox(width: 8),
                      Text('DEV: Switch Role', style: GoogleFonts.inter(color: FocusColors.accent, fontSize: 13, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Development tool for testing different role UIs', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 11)),
                  const SizedBox(height: 12),
                  BlocBuilder<RoleCubit, RoleState>(
                    builder: (context, roleState) => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: UserRole.values.map((role) {
                        final isActive = roleState.role == role;
                        return GestureDetector(
                          onTap: () {
                            context.read<RoleCubit>().setRole(role);
                            context.go(context.read<RoleCubit>().state.defaultRoute);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isActive ? FocusColors.accent : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: isActive ? FocusColors.accent : FocusColors.border),
                            ),
                            child: Text(
                              role.name.toUpperCase(),
                              style: GoogleFonts.inter(
                                color: isActive ? Colors.black : FocusColors.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Notifications preferences
            Text('NOTIFICATION PREFERENCES', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
            const SizedBox(height: 12),
            _toggleRow('Push Notifications', _pushNotifications, (v) => setState(() => _pushNotifications = v)),
            _toggleRow('Email Updates', _emailUpdates, (v) => setState(() => _emailUpdates = v)),
            _toggleRow('SMS Alerts', _smsAlerts, (v) => setState(() => _smsAlerts = v)),
            const SizedBox(height: 24),

            // Appearance
            Text('APPEARANCE', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: cardDecoration(),
              child: Row(
                children: [
                  const Icon(Icons.dark_mode, color: FocusColors.textSecondary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Dark Mode', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 14))),
                  Switch(
                    value: true,
                    onChanged: null,
                    activeColor: FocusColors.accent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // App info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('APP INFO', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
                  const SizedBox(height: 8),
                  Text('Focus- Venue Operations', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 14)),
                  Text('Version 1.0.0', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout
            GestureDetector(
              onTap: () => context.go('/splash'),
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(color: FocusColors.error, borderRadius: BorderRadius.circular(8)),
                alignment: Alignment.center,
                child: Text('SIGN OUT', style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: cardDecoration(),
      child: Row(
        children: [
          Expanded(child: Text(label, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 14))),
          Switch(value: value, onChanged: onChanged, activeColor: FocusColors.accent),
        ],
      ),
    );
  }
}
