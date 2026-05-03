import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/design_constants.dart';

const _kTags = ['VIP', 'REGULAR', 'BIRTHDAY', 'CORPORATE', 'FIRST VISIT', 'HIGH SPENDER', 'INFLUENCER', 'LOYAL GUEST'];

class CompleteTableSheet extends StatefulWidget {
  final String tableLabel;
  final double? currentSpend;
  final VoidCallback onCompleted;

  const CompleteTableSheet({
    super.key,
    required this.tableLabel,
    this.currentSpend,
    required this.onCompleted,
  });

  @override
  State<CompleteTableSheet> createState() => _CompleteTableSheetState();
}

class _CompleteTableSheetState extends State<CompleteTableSheet> {
  final _subtotalCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  bool _isCash = true;
  final Set<String> _selectedTags = {};

  @override
  void initState() {
    super.initState();
    if (widget.currentSpend != null) {
      _subtotalCtrl.text = widget.currentSpend!.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _subtotalCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: FocusColors.elevated,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: FocusColors.textSecondary.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            // Title
            Row(
              children: [
                const Icon(Icons.receipt_long_outlined, color: FocusColors.accent, size: 20),
                const SizedBox(width: 8),
                Text('COMPLETE TABLE ${widget.tableLabel}', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
              ],
            ),
            const SizedBox(height: 20),

            // ── Final Subtotal ──
            _sectionLabel('FINAL SUBTOTAL'),
            const SizedBox(height: 8),
            TextField(
              controller: _subtotalCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800),
              decoration: InputDecoration(
                prefixText: '\$  ',
                prefixStyle: GoogleFonts.inter(color: FocusColors.accent, fontSize: 22, fontWeight: FontWeight.w800),
                hintText: '0.00',
                hintStyle: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 22),
                filled: true,
                fillColor: FocusColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: FocusColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: FocusColors.border)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: FocusColors.accent)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),

            // ── Payment Method ──
            _sectionLabel('PAYMENT METHOD'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _paymentOption(label: 'CASH', icon: Icons.payments_outlined, selected: _isCash, onTap: () => setState(() => _isCash = true))),
                const SizedBox(width: 10),
                Expanded(child: _paymentOption(label: 'CREDIT / CARD', icon: Icons.credit_card_outlined, selected: !_isCash, onTap: () => setState(() => _isCash = false))),
              ],
            ),
            const SizedBox(height: 20),

            // ── CRM Profile ──
            _sectionLabel('PAYEE PROFILE (CRM)'),
            const SizedBox(height: 8),
            _formField('Full Name', _nameCtrl, Icons.person_outline),
            const SizedBox(height: 10),
            _formField('Email Address', _emailCtrl, Icons.email_outlined),
            const SizedBox(height: 10),
            _formField('Address (optional)', _addressCtrl, Icons.home_outlined),
            const SizedBox(height: 20),

            // ── Customer Tags ──
            _sectionLabel('CUSTOMER TAGS'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _kTags.map((tag) {
                final selected = _selectedTags.contains(tag);
                return GestureDetector(
                  onTap: () => setState(() {
                    if (selected) _selectedTags.remove(tag); else _selectedTags.add(tag);
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? FocusColors.accent : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: selected ? FocusColors.accent : FocusColors.border),
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.inter(
                        color: selected ? Colors.black : FocusColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // ── Confirm Button ──
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                widget.onCompleted();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Table ${widget.tableLabel} closed · ${_isCash ? 'Cash' : 'Card'} · \$${_subtotalCtrl.text}'),
                    backgroundColor: FocusColors.success,
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(color: FocusColors.success, borderRadius: BorderRadius.circular(10)),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text('COMPLETE & CLOSE TABLE', style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(text, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2));
  }

  Widget _paymentOption({required String label, required IconData icon, required bool selected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: selected ? FocusColors.accent.withValues(alpha: 0.15) : FocusColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? FocusColors.accent : FocusColors.border, width: selected ? 2 : 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? FocusColors.accent : FocusColors.textSecondary, size: 18),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.inter(color: selected ? FocusColors.accent : FocusColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _formField(String hint, TextEditingController ctrl, IconData icon) {
    return TextField(
      controller: ctrl,
      style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 13),
        prefixIcon: Icon(icon, color: FocusColors.accent, size: 18),
        filled: true,
        fillColor: FocusColors.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: FocusColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: FocusColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: FocusColors.accent)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
