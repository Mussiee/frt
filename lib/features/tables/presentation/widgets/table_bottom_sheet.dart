import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/design_constants.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../data/mock_tables.dart';
import '../../../../shared/widgets/table_circle.dart';

class TableBottomSheet extends StatelessWidget {
  final MockTable table;
  final VoidCallback? onMarkFree;
  final void Function(String name, String? phone, int guestCount)? onAssignCustomer;
  final VoidCallback? onAssignServer;
  final VoidCallback? onMarkNoShow;

  const TableBottomSheet({
    super.key,
    required this.table,
    this.onMarkFree,
    this.onAssignCustomer,
    this.onAssignServer,
    this.onMarkNoShow,
  });

  StatusType get _statusType {
    switch (table.status) {
      case TableStatus.free:
        return StatusType.free;
      case TableStatus.reserved:
        return StatusType.reserved;
      case TableStatus.occupied:
        return StatusType.occupied;
    }
  }

  String get _statusLabel {
    switch (table.status) {
      case TableStatus.free:
        return 'FREE';
      case TableStatus.reserved:
        return 'RESERVED';
      case TableStatus.occupied:
        return 'OCCUPIED';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: FocusColors.elevated,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: FocusColors.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.restaurant, color: FocusColors.accent, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'TABLE ${table.label}',
                    style: GoogleFonts.inter(
                      color: FocusColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  StatusChip(label: _statusLabel, type: _statusType),
                ],
              ),
              const SizedBox(height: 20),
              if (table.status != TableStatus.free) _buildInfoSection(),
              if (table.status == TableStatus.occupied) ...[
                const SizedBox(height: 16),
                _buildBillingSection(),
              ],
              const SizedBox(height: 20),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildInfoCard(
              'CUSTOMER SECTION',
              Icons.person_outline,
              table.customerName ?? 'Unassigned',
              table.customerPhone,
            )),
            const SizedBox(width: 12),
            Expanded(child: _buildInfoCard(
              'SERVER SECTION',
              Icons.room_service_outlined,
              table.serverName ?? 'Unassigned',
              table.serverRole,
            )),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            if (table.reservationDate != null)
              Expanded(
                child: _buildDetailItem(Icons.calendar_today_outlined, 'DATE', table.reservationDate!),
              ),
            if (table.guestCount != null)
              Expanded(
                child: _buildDetailItem(Icons.groups_outlined, 'PARTY SIZE', '${table.guestCount!.toString().padLeft(2, '0')} GUESTS'),
              ),
          ],
        ),
        if (table.area != null) ...[
          const SizedBox(height: 12),
          _buildDetailItem(Icons.place_outlined, 'AREA', table.area!),
        ],
      ],
    );
  }

  Widget _buildInfoCard(String header, IconData icon, String title, String? subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: FocusColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: FocusColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: FocusColors.textSecondary, size: 12),
              const SizedBox(width: 4),
              Text(
                header,
                style: GoogleFonts.inter(
                  color: FocusColors.textSecondary,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              color: FocusColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                color: FocusColors.accent,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: FocusColors.accent, size: 16),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                color: FocusColors.textSecondary,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.inter(
                color: FocusColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBillingSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: FocusColors.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: FocusColors.accent, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL SPEND',
                    style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 1),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${table.totalSpend?.toStringAsFixed(2) ?? '0.00'}',
                    style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              if (table.sessionDuration != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'SESSION DURATION',
                      style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 1),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      table.sessionDuration!,
                      style: GoogleFonts.inter(color: FocusColors.accent, fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
            ],
          ),
          if (table.notes != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.info_outline, color: FocusColors.accent, size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    table.notes!,
                    style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    switch (table.status) {
      case TableStatus.free:
        return Row(
          children: [
            Expanded(child: _actionButton('ASSIGN CUSTOMER', FocusColors.accent, Colors.black, () => _showWalkInForm(context))),
            const SizedBox(width: 10),
            Expanded(child: _actionButton('ASSIGN SERVER', Colors.transparent, FocusColors.accent, onAssignServer, outlined: true)),
          ],
        );
      case TableStatus.reserved:
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: _actionButton('CHECK-IN GUEST', FocusColors.success, Colors.white, () => Navigator.pop(context))),
                const SizedBox(width: 10),
                Expanded(child: _actionButton('ASSIGN SERVER', FocusColors.accent, Colors.black, onAssignServer)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onMarkFree,
                    child: Text(
                      'CANCEL RESERVATION',
                      style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                    ),
                  ),
                ),
                Expanded(
                  child: _actionButton('NO SHOW', FocusColors.error, Colors.white, onMarkNoShow),
                ),
              ],
            ),
          ],
        );
      case TableStatus.occupied:
        return Row(
          children: [
            Expanded(child: _actionButton('ADD NOTES', Colors.transparent, FocusColors.accent, () => Navigator.pop(context), outlined: true)),
            const SizedBox(width: 10),
            Expanded(child: _actionButton('MARK AS FREE', FocusColors.error, Colors.white, onMarkFree)),
            const SizedBox(width: 10),
            SizedBox(
              width: 44,
              child: _actionButton('', Colors.transparent, FocusColors.textSecondary, () => Navigator.pop(context), outlined: true, icon: Icons.close),
            ),
          ],
        );
    }
  }

  void _showWalkInForm(BuildContext context) {
    Navigator.pop(context);
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final guestCtrl = TextEditingController(text: '2');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: FocusColors.elevated,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: FocusColors.textSecondary.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 16),
              Text('WALK-IN — TABLE ${table.label}', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
              const SizedBox(height: 20),
              _formField('Customer Name *', nameCtrl, Icons.person_outline),
              const SizedBox(height: 12),
              _formField('Phone (optional)', phoneCtrl, Icons.phone_outlined),
              const SizedBox(height: 12),
              _formField('Guest Count', guestCtrl, Icons.groups_outlined, isNumber: true),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: FocusColors.border)),
                        alignment: Alignment.center,
                        child: Text('CANCEL', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        final name = nameCtrl.text.trim();
                        if (name.isEmpty) return;
                        final phone = phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim();
                        final guests = int.tryParse(guestCtrl.text) ?? 2;
                        Navigator.pop(ctx);
                        onAssignCustomer?.call(name, phone, guests);
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(color: FocusColors.accent, borderRadius: BorderRadius.circular(8)),
                        alignment: Alignment.center,
                        child: Text('ASSIGN', style: GoogleFonts.inter(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _formField(String hint, TextEditingController controller, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 13),
        prefixIcon: Icon(icon, color: FocusColors.accent, size: 18),
        filled: true,
        fillColor: FocusColors.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: FocusColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: FocusColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: FocusColors.accent)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _actionButton(String label, Color bg, Color fg, VoidCallback? onTap, {bool outlined = false, IconData? icon}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: outlined ? Border.all(color: FocusColors.border) : null,
        ),
        alignment: Alignment.center,
        child: icon != null
            ? Icon(icon, color: fg, size: 20)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (label == 'ADD NOTES') ...[
                    Icon(Icons.edit_note, color: fg, size: 16),
                    const SizedBox(width: 4),
                  ],
                  if (label == 'MARK AS FREE') ...[
                    Icon(Icons.lock_open, color: fg, size: 14),
                    const SizedBox(width: 4),
                  ],
                  if (label == 'NO SHOW') ...[
                    Icon(Icons.person_off, color: fg, size: 14),
                    const SizedBox(width: 4),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      style: GoogleFonts.inter(color: fg, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
