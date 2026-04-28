import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/design_constants.dart';
import '../../../../shared/widgets/avatar_widget.dart';
import '../../../../shared/widgets/search_bar_widget.dart';
import '../../../../shared/widgets/section_badge.dart';
import '../../data/mock_checked_in.dart';

class CheckedInScreen extends StatefulWidget {
  const CheckedInScreen({super.key});

  @override
  State<CheckedInScreen> createState() => _CheckedInScreenState();
}

class _CheckedInScreenState extends State<CheckedInScreen> {
  String _search = '';

  List<MockCheckedInGuest> get _filtered {
    if (_search.isEmpty) return mockCheckedInGuests;
    return mockCheckedInGuests.where((g) => g.name.toLowerCase().contains(_search.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text('CHECKED-IN GUESTS', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _statBox('Checked In', '${mockCheckedInGuests.length}', FocusColors.success),
                const SizedBox(width: 10),
                _statBox('Expected', '120', FocusColors.textSecondary),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SearchBarWidget(hint: 'Search guests...', onChanged: (v) => setState(() => _search = v)),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final g = items[i];
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: FocusColors.border, width: 0.5))),
                  child: Row(
                    children: [
                      AvatarWidget(name: g.name, size: 38),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(g.name, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text('Table ${g.tableNumber}', style: GoogleFonts.inter(color: FocusColors.accent, fontSize: 11, fontWeight: FontWeight.w600)),
                                const SizedBox(width: 8),
                                Text('${g.partySize} guests', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 11)),
                                const SizedBox(width: 8),
                                Text(g.checkInTime, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 11)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            SectionBadge(section: g.section),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.confirmation_number_outlined, color: FocusColors.accent, size: 20),
                        onPressed: () {},
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: cardDecoration(),
        child: Column(
          children: [
            Text(label, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
            const SizedBox(height: 4),
            Text(value, style: GoogleFonts.inter(color: color, fontSize: 24, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}
