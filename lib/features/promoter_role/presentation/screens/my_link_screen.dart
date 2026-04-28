import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../shared/design_constants.dart';
import '../../../../shared/widgets/stats_card.dart';
import '../../data/mock_promoter_stats.dart';

class MyLinkScreen extends StatelessWidget {
  const MyLinkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('MY LINK', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('Share your referral link to earn commissions', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 24),

            // Referral code
            Center(
              child: Text(
                MockPromoterSelfStats.referralCode,
                style: GoogleFonts.inter(color: FocusColors.accent, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: 3),
              ),
            ),
            const SizedBox(height: 24),

            // QR Code
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: QrImageView(
                  data: MockPromoterSelfStats.referralLink,
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                  eyeStyle: const QrEyeStyle(color: Colors.black, eyeShape: QrEyeShape.square),
                  dataModuleStyle: const QrDataModuleStyle(color: Colors.black, dataModuleShape: QrDataModuleShape.square),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Center(
              child: Text(
                MockPromoterSelfStats.referralLink,
                style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12),
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Link copied!'), backgroundColor: FocusColors.accent)),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(color: FocusColors.accent, borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.copy, color: Colors.black, size: 18),
                          const SizedBox(width: 8),
                          Text('COPY LINK', style: GoogleFonts.inter(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Share sheet opened!'), backgroundColor: FocusColors.accent)),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: FocusColors.border)),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.share, color: FocusColors.textPrimary, size: 18),
                          const SizedBox(width: 8),
                          Text('SHARE', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Stats
            Row(
              children: [
                const Expanded(child: StatsCard(label: 'Link Clicks', value: '1,247', trend: 'All time')),
                const SizedBox(width: 10),
                const Expanded(child: StatsCard(label: 'Conversions This Week', value: '8', trend: '6.4% rate')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
