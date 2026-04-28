import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design_constants.dart';
import 'app_sidebar.dart';

class RoleShellScreen extends StatelessWidget {
  final Widget child;

  const RoleShellScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FocusColors.background,
      appBar: AppBar(
        backgroundColor: FocusColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: FocusColors.accent),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(
          'COMMAND CENTER',
          style: GoogleFonts.inter(
            color: FocusColors.accent,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: FocusColors.textSecondary, size: 22),
            onPressed: () => context.go('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.history_outlined, color: FocusColors.textSecondary, size: 22),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
      drawer: const AppSidebar(),
      body: child,
    );
  }
}
