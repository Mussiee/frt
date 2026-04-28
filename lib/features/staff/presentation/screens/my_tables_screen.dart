import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/design_constants.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../../shared/widgets/table_circle.dart';
import '../../../tables/data/mock_tables.dart';

class MyTablesScreen extends StatelessWidget {
  const MyTablesScreen({super.key});

  List<MockTable> get _assignedTables =>
      mockTables.where((t) => t.serverName != null && t.status != TableStatus.free).take(3).toList();

  StatusType _statusType(TableStatus s) {
    switch (s) {
      case TableStatus.free: return StatusType.free;
      case TableStatus.reserved: return StatusType.reserved;
      case TableStatus.occupied: return StatusType.occupied;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tables = _assignedTables;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('MY TABLES', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('${tables.length} tables assigned', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 20),
            Expanded(
              child: tables.isEmpty
                  ? Center(child: Text('No tables assigned', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 16)))
                  : ListView.separated(
                      itemCount: tables.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final t = tables[i];
                        return GestureDetector(
                          onTap: () => context.go('/my-tables/${t.id}'),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: cardDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('TABLE ${t.label}', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
                                    const Spacer(),
                                    StatusChip(
                                      label: t.status == TableStatus.occupied ? 'OCCUPIED' : 'RESERVED',
                                      type: _statusType(t.status),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                if (t.customerName != null) ...[
                                  Row(
                                    children: [
                                      const Icon(Icons.person_outline, color: FocusColors.textSecondary, size: 16),
                                      const SizedBox(width: 8),
                                      Text(t.customerName!, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 14)),
                                      if (t.guestCount != null) ...[
                                        const SizedBox(width: 12),
                                        const Icon(Icons.groups_outlined, color: FocusColors.textSecondary, size: 16),
                                        const SizedBox(width: 4),
                                        Text('${t.guestCount} guests', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12)),
                                      ],
                                    ],
                                  ),
                                ],
                                if (t.area != null) ...[
                                  const SizedBox(height: 8),
                                  Text(t.area!, style: GoogleFonts.inter(color: FocusColors.accent, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                                ],
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    _quickAction('ADD NOTE', Icons.note_add_outlined),
                                    const SizedBox(width: 8),
                                    if (t.status == TableStatus.occupied)
                                      _quickAction('UPDATE SPEND', Icons.attach_money),
                                    const Spacer(),
                                    _quickAction('MARK FREE', Icons.lock_open, color: FocusColors.error),
                                  ],
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
      ),
    );
  }

  Widget _quickAction(String label, IconData icon, {Color color = FocusColors.textSecondary}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: FocusColors.border)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(label, style: GoogleFonts.inter(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
