import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/design_constants.dart';
import '../../data/mock_promoter_stats.dart';

const _kVenues = ['Mr. Black — Downtown', 'Eclipse Nightclub', 'Noir Rooftop Bar', 'The Vault VIP Club'];

class PromoCompanyScreen extends StatefulWidget {
  const PromoCompanyScreen({super.key});

  @override
  State<PromoCompanyScreen> createState() => _PromoCompanyScreenState();
}

class _PromoCompanyScreenState extends State<PromoCompanyScreen> {
  final _nameCtrl = TextEditingController(text: 'Thorne Entertainment');
  final _bioCtrl = TextEditingController(text: 'Premium nightlife promotions across NYC.');
  final _igCtrl = TextEditingController(text: '@thorneent');
  final _fbCtrl = TextEditingController();
  String? _selectedVenue;
  bool _requestSent = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    _igCtrl.dispose();
    _fbCtrl.dispose();
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
            Text('MY COMPANY', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('Manage your promo company profile', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 24),

            // Company card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('COMPANY PROFILE'),
                  const SizedBox(height: 16),
                  // Avatar
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: FocusColors.accent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Text('TE', style: GoogleFonts.inter(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w800)),
                        ),
                        Positioned(
                          bottom: 0, right: 0,
                          child: Container(
                            width: 26, height: 26,
                            decoration: BoxDecoration(color: FocusColors.surface, shape: BoxShape.circle, border: Border.all(color: FocusColors.border)),
                            child: const Icon(Icons.camera_alt, color: FocusColors.accent, size: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _formField('Company Name', _nameCtrl, Icons.business_outlined),
                  const SizedBox(height: 12),
                  _formField('Bio / Description', _bioCtrl, Icons.info_outline, maxLines: 3),
                  const SizedBox(height: 12),
                  _formField('Instagram Handle', _igCtrl, Icons.alternate_email),
                  const SizedBox(height: 12),
                  _formField('Facebook Page', _fbCtrl, Icons.facebook),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Company profile saved!'), backgroundColor: FocusColors.success),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 46,
                      decoration: BoxDecoration(color: FocusColors.accent, borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      child: Text('SAVE PROFILE', style: GoogleFonts.inter(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Venue membership request
            Container(
              padding: const EdgeInsets.all(16),
              decoration: cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('REQUEST TO JOIN VENUE'),
                  const SizedBox(height: 4),
                  Text('Send a partnership request to a venue owner', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 16),
                  // Venue dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: FocusColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: FocusColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedVenue,
                        hint: Text('Select a venue...', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 13)),
                        isExpanded: true,
                        dropdownColor: FocusColors.elevated,
                        icon: const Icon(Icons.keyboard_arrow_down, color: FocusColors.accent),
                        items: _kVenues.map((v) => DropdownMenuItem(
                          value: v,
                          child: Text(v, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 13)),
                        )).toList(),
                        onChanged: (v) => setState(() { _selectedVenue = v; _requestSent = false; }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_requestSent)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: FocusColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: FocusColors.success.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: FocusColors.success, size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text('Request sent to $_selectedVenue! Waiting for approval.', style: GoogleFonts.inter(color: FocusColors.success, fontSize: 12, fontWeight: FontWeight.w600))),
                        ],
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: _selectedVenue == null ? null : () => setState(() => _requestSent = true),
                      child: Container(
                        width: double.infinity,
                        height: 46,
                        decoration: BoxDecoration(
                          color: _selectedVenue != null ? FocusColors.accent : FocusColors.border,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text('SEND JOIN REQUEST', style: GoogleFonts.inter(color: _selectedVenue != null ? Colors.black : FocusColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w700)),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Active memberships
            Container(
              padding: const EdgeInsets.all(16),
              decoration: cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('ACTIVE MEMBERSHIPS'),
                  const SizedBox(height: 12),
                  _membershipRow('Mr. Black — Downtown', 'ACTIVE', FocusColors.success, MockPromoterSelfStats.joinDate),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _membershipRow(String venue, String status, Color statusColor, String since) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: FocusColors.border, width: 0.5))),
      child: Row(
        children: [
          const Icon(Icons.location_city_outlined, color: FocusColors.accent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(venue, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                Text('Since $since', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
            child: Text(status, style: GoogleFonts.inter(color: statusColor, fontSize: 10, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(text, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2));
  }

  Widget _formField(String hint, TextEditingController ctrl, IconData icon, {int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 13),
        prefixIcon: maxLines == 1 ? Icon(icon, color: FocusColors.accent, size: 18) : null,
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
