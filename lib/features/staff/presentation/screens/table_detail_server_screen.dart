import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/design_constants.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../../shared/widgets/table_circle.dart';
import '../../../tables/data/mock_tables.dart';
import '../widgets/complete_table_sheet.dart';

class TableDetailServerScreen extends StatefulWidget {
  final String id;
  const TableDetailServerScreen({super.key, required this.id});

  @override
  State<TableDetailServerScreen> createState() => _TableDetailServerScreenState();
}

class _TableDetailServerScreenState extends State<TableDetailServerScreen> {
  late MockTable _table;
  final _notesController = TextEditingController();
  final _spendController = TextEditingController();
  final List<_NoteEntry> _notes = [
    _NoteEntry('Guest requested extra ice bucket', '10:15 PM'),
    _NoteEntry('Bottle service started - Dom Perignon', '10:30 PM'),
    _NoteEntry('Birthday cake arriving at 11:00 PM', '10:45 PM'),
  ];

  @override
  void initState() {
    super.initState();
    _table = mockTables.firstWhere((t) => t.id == widget.id, orElse: () => mockTables.first);
    _spendController.text = _table.totalSpend?.toStringAsFixed(2) ?? '0.00';
  }

  @override
  void dispose() {
    _notesController.dispose();
    _spendController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => context.canPop() ? context.pop() : context.go('/my-tables'),
                  child: const Icon(Icons.arrow_back, color: FocusColors.accent),
                ),
                const SizedBox(width: 12),
                Text('TABLE ${_table.label}', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                const Spacer(),
                StatusChip(
                  label: _table.status == TableStatus.occupied ? 'OCCUPIED' : 'RESERVED',
                  type: _table.status == TableStatus.occupied ? StatusType.occupied : StatusType.reserved,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Guest info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('GUEST INFORMATION', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
                  const SizedBox(height: 12),
                  _infoRow(Icons.person_outline, 'Guest', _table.customerName ?? 'Unassigned'),
                  _infoRow(Icons.phone_outlined, 'Phone', _table.customerPhone ?? '-'),
                  _infoRow(Icons.groups_outlined, 'Party Size', '${_table.guestCount ?? 0} guests'),
                  if (_table.sessionDuration != null)
                    _infoRow(Icons.timer_outlined, 'Session', _table.sessionDuration!),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Spend tracking
            Container(
              padding: const EdgeInsets.all(16),
              decoration: cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SPEND TRACKING', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _spendController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700),
                          decoration: InputDecoration(
                            prefixText: '\$ ',
                            prefixStyle: GoogleFonts.inter(color: FocusColors.accent, fontSize: 20, fontWeight: FontWeight.w700),
                            filled: true,
                            fillColor: FocusColors.surface,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: FocusColors.border)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: FocusColors.border)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Spend updated'), backgroundColor: FocusColors.accent)),
                        child: Container(
                          height: 52,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(color: FocusColors.accent, borderRadius: BorderRadius.circular(8)),
                          alignment: Alignment.center,
                          child: Text('UPDATE', style: GoogleFonts.inter(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Notes
            Container(
              padding: const EdgeInsets.all(16),
              decoration: cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NOTES', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Add a note...',
                      hintStyle: GoogleFonts.inter(color: FocusColors.textSecondary.withValues(alpha: 0.5)),
                      filled: true,
                      fillColor: FocusColors.surface,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: FocusColors.border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: FocusColors.border)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        if (_notesController.text.trim().isNotEmpty) {
                          setState(() {
                            _notes.insert(0, _NoteEntry(_notesController.text.trim(), '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} PM'));
                            _notesController.clear();
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: FocusColors.accent, borderRadius: BorderRadius.circular(6)),
                        child: Text('SAVE NOTE', style: GoogleFonts.inter(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._notes.map((n) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(n.time, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 11)),
                        const SizedBox(width: 10),
                        Expanded(child: Text(n.text, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 13))),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Mark free
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => CompleteTableSheet(
                    tableLabel: _table.label,
                    currentSpend: _table.totalSpend,
                    onCompleted: () {
                      if (context.mounted) {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/my-tables');
                        }
                      }
                    },
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(color: FocusColors.success, borderRadius: BorderRadius.circular(8)),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.receipt_long_outlined, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text('COMPLETE TABLE', style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: FocusColors.accent, size: 16),
          const SizedBox(width: 10),
          SizedBox(width: 80, child: Text(label, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12))),
          Expanded(child: Text(value, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}

class _NoteEntry {
  final String text;
  final String time;
  _NoteEntry(this.text, this.time);
}
