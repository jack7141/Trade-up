import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';

class MetricsWidget extends StatelessWidget {
  const MetricsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
        children: [
          _MetricItem(title: 'Win Rate', value: '62.5%'),
          _MetricItem(title: 'Avg. P/L', value: '+\$89.8', isPositive: true),
          _MetricItem(
            title: 'Largest Win',
            value: '+\$450.2',
            isPositive: true,
          ),
          _MetricItem(
            title: 'Largest Loss',
            value: '-\$120.5',
            isPositive: false,
          ),
        ],
      ),
    );
  }
}

// 핵심 지표 아이템
class _MetricItem extends StatelessWidget {
  final String title;
  final String value;
  final bool? isPositive;

  const _MetricItem({
    required this.title,
    required this.value,
    this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    Color valueColor = AppTheme.primaryText;
    if (isPositive != null) {
      valueColor = isPositive!
          ? AppTheme.positiveColor
          : AppTheme.negativeColor;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              color: AppTheme.secondaryText,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.bebasNeue(
              color: valueColor,
              fontSize: 24,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
