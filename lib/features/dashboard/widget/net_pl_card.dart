import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';

class NetPlCardWidget extends StatelessWidget {
  const NetPlCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Net P/L',
              style: GoogleFonts.montserrat(
                color: AppTheme.secondaryText,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '+\$2,875.50',
              style: GoogleFonts.bebasNeue(
                color: AppTheme.positiveColor,
                fontSize: 40,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
