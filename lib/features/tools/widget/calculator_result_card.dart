import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';
import 'package:trade_up/features/tools/view/calculators/position_size_calculator_screen.dart';

class CalculatorResultCard extends StatelessWidget {
  final String title;
  final List<ResultItem> results;

  const CalculatorResultCard({
    super.key,
    required this.title,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.positiveColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: AppTheme.positiveColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  color: AppTheme.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 결과 리스트
          ...results.map(
            (result) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildResultItem(result),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(ResultItem result) {
    return Row(
      children: [
        // 아이콘
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: result.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(result.icon, color: result.color, size: 14),
        ),

        const SizedBox(width: 12),

        // 라벨
        Expanded(
          child: Text(
            result.label,
            style: GoogleFonts.montserrat(
              color: AppTheme.secondaryText,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // 값
        Text(
          result.value,
          style: GoogleFonts.robotoMono(
            color: result.color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
