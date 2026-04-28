import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design_constants.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;
  final String? summary;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          if (summary != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                summary!,
                style: GoogleFonts.inter(
                  color: FocusColors.textSecondary,
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _NavButton(
                label: 'Previous',
                enabled: currentPage > 1,
                onTap: () => onPageChanged(currentPage - 1),
              ),
              const SizedBox(width: 8),
              ...List.generate(
                totalPages > 3 ? 3 : totalPages,
                (i) {
                  final page = i + 1;
                  final isActive = page == currentPage;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: GestureDetector(
                      onTap: () => onPageChanged(page),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isActive ? FocusColors.accent : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: isActive ? null : Border.all(color: FocusColors.border),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$page',
                          style: GoogleFonts.inter(
                            color: isActive ? Colors.black : FocusColors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              _NavButton(
                label: 'Next',
                enabled: currentPage < totalPages,
                onTap: () => onPageChanged(currentPage + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _NavButton({required this.label, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: enabled ? FocusColors.textPrimary : FocusColors.textSecondary.withValues(alpha: 0.4),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
