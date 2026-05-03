import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../shared/design_constants.dart';
import '../../../../shared/widgets/stats_card.dart';
import '../../data/mock_promoter_stats.dart';

class _PromoLink {
  final String id;
  final String channel;
  final String code;
  final String url;
  final IconData icon;
  final Color color;
  final int clicks;
  final int conversions;

  const _PromoLink({
    required this.id,
    required this.channel,
    required this.code,
    required this.url,
    required this.icon,
    required this.color,
    required this.clicks,
    required this.conversions,
  });
}

final _defaultLinks = [
  _PromoLink(id: 'l1', channel: 'Instagram', code: 'JTHORNE-IG', url: 'https://focus.club/r/JTHORNE-IG', icon: Icons.camera_alt_outlined, color: Color(0xFFE1306C), clicks: 842, conversions: 31),
  _PromoLink(id: 'l2', channel: 'Facebook', code: 'JTHORNE-FB', url: 'https://focus.club/r/JTHORNE-FB', icon: Icons.facebook, color: Color(0xFF1877F2), clicks: 213, conversions: 8),
  _PromoLink(id: 'l3', channel: 'Call-In', code: 'JTHORNE-CALL', url: 'https://focus.club/r/JTHORNE-CALL', icon: Icons.phone_outlined, color: Color(0xFF34C759), clicks: 107, conversions: 5),
  _PromoLink(id: 'l4', channel: 'Direct', code: 'JTHORNE2023', url: MockPromoterSelfStats.referralLink, icon: Icons.link, color: FocusColors.accent, clicks: 85, conversions: 3),
];

class MyLinkScreen extends StatefulWidget {
  const MyLinkScreen({super.key});

  @override
  State<MyLinkScreen> createState() => _MyLinkScreenState();
}

class _MyLinkScreenState extends State<MyLinkScreen> {
  late List<_PromoLink> _links;
  String? _expandedId;

  @override
  void initState() {
    super.initState();
    _links = List.of(_defaultLinks);
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
                Text('MY LINKS', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800)),
                const Spacer(),
                GestureDetector(
                  onTap: () => _showCreateLinkSheet(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(color: FocusColors.accent, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        const Icon(Icons.add, color: Colors.black, size: 16),
                        const SizedBox(width: 4),
                        Text('NEW LINK', style: GoogleFonts.inter(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('Manage channel-specific referral links', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 24),

            // Primary QR
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: QrImageView(
                  data: MockPromoterSelfStats.referralLink,
                  version: QrVersions.auto,
                  size: 160,
                  backgroundColor: Colors.white,
                  eyeStyle: const QrEyeStyle(color: Colors.black, eyeShape: QrEyeShape.square),
                  dataModuleStyle: const QrDataModuleStyle(color: Colors.black, dataModuleShape: QrDataModuleShape.square),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(MockPromoterSelfStats.referralLink, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 11)),
            ),
            const SizedBox(height: 24),

            // Stats row
            Row(
              children: [
                const Expanded(child: StatsCard(label: 'Total Clicks', value: '1,247', trend: 'All time')),
                const SizedBox(width: 10),
                const Expanded(child: StatsCard(label: 'Conversions', value: '47', trend: 'All channels')),
              ],
            ),
            const SizedBox(height: 24),

            // Links list
            Text('CHANNEL LINKS', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
            const SizedBox(height: 12),
            ..._links.map((link) => _buildLinkCard(context, link)),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkCard(BuildContext context, _PromoLink link) {
    final isExpanded = _expandedId == link.id;
    return GestureDetector(
      onTap: () => setState(() => _expandedId = isExpanded ? null : link.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: FocusColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isExpanded ? link.color.withValues(alpha: 0.5) : FocusColors.border),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(color: link.color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                    child: Icon(link.icon, color: link.color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(link.channel, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
                        Text(link.code, style: GoogleFonts.inter(color: link.color, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${link.clicks}', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w800)),
                      Text('clicks', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: FocusColors.textSecondary, size: 20),
                ],
              ),
            ),
            if (isExpanded) ...[
              Container(height: 1, color: FocusColors.border),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(link.url, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 11)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _statPill('${link.clicks} clicks', FocusColors.textSecondary),
                        const SizedBox(width: 8),
                        _statPill('${link.conversions} booked', FocusColors.success),
                        const SizedBox(width: 8),
                        _statPill('${(link.conversions / link.clicks * 100).toStringAsFixed(1)}%', FocusColors.accent),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${link.code} copied!'), backgroundColor: FocusColors.accent)),
                            child: Container(
                              height: 38,
                              decoration: BoxDecoration(color: FocusColors.accent, borderRadius: BorderRadius.circular(6)),
                              alignment: Alignment.center,
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                const Icon(Icons.copy, color: Colors.black, size: 14),
                                const SizedBox(width: 4),
                                Text('COPY', style: GoogleFonts.inter(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w700)),
                              ]),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Share sheet opened'), backgroundColor: FocusColors.accent)),
                            child: Container(
                              height: 38,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: FocusColors.border)),
                              alignment: Alignment.center,
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                const Icon(Icons.share, color: FocusColors.textPrimary, size: 14),
                                const SizedBox(width: 4),
                                Text('SHARE', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w700)),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statPill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: GoogleFonts.inter(color: color, fontSize: 10, fontWeight: FontWeight.w700)),
    );
  }

  void _showCreateLinkSheet(BuildContext context) {
    final channels = ['Instagram', 'Facebook', 'TikTok', 'Twitter/X', 'Call-In', 'WhatsApp', 'Direct'];
    String? selected;
    showModalBottomSheet(
      context: context,
      backgroundColor: FocusColors.elevated,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: FocusColors.textSecondary.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 16),
                Text('CREATE NEW LINK', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 16),
                Text('SELECT CHANNEL', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: channels.map((ch) => GestureDetector(
                    onTap: () => setSt(() => selected = ch),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected == ch ? FocusColors.accent : FocusColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: selected == ch ? FocusColors.accent : FocusColors.border),
                      ),
                      child: Text(ch, style: GoogleFonts.inter(color: selected == ch ? Colors.black : FocusColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: selected == null ? null : () {
                    Navigator.pop(ctx);
                    setState(() {
                      _links.add(_PromoLink(
                        id: 'l${_links.length + 1}',
                        channel: selected!,
                        code: 'JTHORNE-${selected!.toUpperCase().replaceAll('/', '')}',
                        url: 'https://focus.club/r/JTHORNE-${selected!.toUpperCase().replaceAll('/', '')}',
                        icon: Icons.link,
                        color: FocusColors.accent,
                        clicks: 0,
                        conversions: 0,
                      ));
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$selected link created!'), backgroundColor: FocusColors.success),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: selected != null ? FocusColors.accent : FocusColors.border,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text('CREATE LINK', style: GoogleFonts.inter(color: selected != null ? Colors.black : FocusColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w700)),
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
