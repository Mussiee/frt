import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/design_constants.dart';
import '../../cubit/scanner_cubit.dart';

Widget _corner(Alignment alignment) {
  final isTop = alignment == Alignment.topLeft || alignment == Alignment.topRight;
  final isLeft = alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;
  return Positioned(
    top: isTop ? 0 : null,
    bottom: isTop ? null : 0,
    left: isLeft ? 0 : null,
    right: isLeft ? null : 0,
    child: Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? const BorderSide(color: FocusColors.accent, width: 3) : BorderSide.none,
          bottom: isTop ? BorderSide.none : const BorderSide(color: FocusColors.accent, width: 3),
          left: isLeft ? const BorderSide(color: FocusColors.accent, width: 3) : BorderSide.none,
          right: isLeft ? BorderSide.none : const BorderSide(color: FocusColors.accent, width: 3),
        ),
      ),
    ),
  );
}

Widget _buildResult(BuildContext context, ScannerState state) {
  final isValid = state.scanResult == 'valid';
  final color = isValid ? FocusColors.success : FocusColors.error;
  final icon = isValid ? Icons.check_circle : Icons.cancel;

  String title;
  if (state.scanResult == 'valid') {
    title = 'VALID TICKET';
  } else if (state.scanResult == 'invalid') {
    title = 'INVALID TICKET';
  } else {
    title = 'ALREADY USED';
  }

  String subtitle;
  if (state.scanResult == 'valid') {
    subtitle = '${state.lastScannedName} · Table 201 · VIP Lounge';
  } else if (state.scanResult == 'invalid') {
    subtitle = 'QR code not recognized';
  } else {
    subtitle = 'This ticket was already scanned at 9:32 PM';
  }

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 24),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.inter(color: color, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        if (isValid) ...[
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Guest checked in successfully!'), backgroundColor: FocusColors.success),
              );
              context.read<ScannerCubit>().resetScan();
            },
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(color: FocusColors.success, borderRadius: BorderRadius.circular(8)),
              alignment: Alignment.center,
              child: Text('CHECK IN', style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ],
    ),
  );
}

class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScannerCubit, ScannerState>(
      builder: (context, state) {
        return SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text('QR SCANNER', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 24),

              // Scanner viewfinder
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: FocusColors.surface,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.qr_code_scanner, color: FocusColors.accent.withValues(alpha: 0.3), size: 80),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Point camera at guest\nticket QR code',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Corner brackets
                          _corner(Alignment.topLeft),
                          _corner(Alignment.topRight),
                          _corner(Alignment.bottomLeft),
                          _corner(Alignment.bottomRight),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Result overlay
              if (state.scanResult != null) _buildResult(context, state),

              // Simulate button
              Padding(
                padding: const EdgeInsets.all(24),
                child: GestureDetector(
                  onTap: () => context.read<ScannerCubit>().simulateScan(),
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(color: FocusColors.accent, borderRadius: BorderRadius.circular(8)),
                    alignment: Alignment.center,
                    child: Text('SIMULATE SCAN', style: GoogleFonts.inter(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
