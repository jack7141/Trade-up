import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';

class NavTab extends StatelessWidget {
  const NavTab({
    super.key,
    required this.index,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.screenWidth,
  });

  final int index;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    // 화면 너비에 비례한 패딩과 크기 계산
    final horizontalPadding = math.max(8.0, math.min(16.0, screenWidth * 0.03));
    final verticalPadding = math.max(6.0, math.min(12.0, screenWidth * 0.02));
    final iconPadding = math.max(6.0, math.min(12.0, screenWidth * 0.02));
    final iconSize = math.max(20.0, math.min(28.0, screenWidth * 0.06));
    final borderRadius = math.max(8.0, math.min(16.0, screenWidth * 0.03));
    final textIconSpacing = math.max(2.0, math.min(6.0, screenWidth * 0.01));
    final fontSize = math.max(9.0, math.min(13.0, screenWidth * 0.028));

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(iconPadding),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.accentColor.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected
                    ? AppTheme.accentColor
                    : AppTheme.secondaryText,
                size: iconSize,
              ),
            ),
            SizedBox(height: textIconSpacing),
            Text(
              label,
              style: GoogleFonts.montserrat(
                color: isSelected
                    ? AppTheme.accentColor
                    : AppTheme.secondaryText,
                fontSize: fontSize,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
