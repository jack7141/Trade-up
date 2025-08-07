import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';
import 'package:trade_up/features/dashboard/widget/trading_calendar_widget.dart';

class FullCalendarScreen extends StatelessWidget {
  static const String routeName = 'full-calendar';
  static const String routePath = '/full-calendar';

  const FullCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Trading Calendar',
          style: GoogleFonts.montserrat(
            color: AppTheme.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: AppTheme.primaryText),
            onPressed: () {
              // TODO: Show filter options
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 월간 통계 요약
            _buildMonthlySummary(),
            const SizedBox(height: 16),

            // 풀사이즈 캘린더
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const TradingCalendarWidget(),
                    const SizedBox(height: 24),

                    // 추가 통계 정보
                    _buildDetailedStats(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlySummary() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.accentColor.withOpacity(0.1),
              AppTheme.surfaceColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderColor, width: 1),
        ),
        child: Column(
          children: [
            Text(
              'February 2025 Summary',
              style: GoogleFonts.montserrat(
                color: AppTheme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total P&L',
                    '\$733',
                    AppTheme.positiveColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Trading Days',
                    '10',
                    AppTheme.accentColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Win Rate',
                    '67%',
                    AppTheme.positiveColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Best Day',
                    '\$511',
                    AppTheme.positiveColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              color: AppTheme.secondaryText,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.bebasNeue(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trading Pattern Analysis',
              style: GoogleFonts.montserrat(
                color: AppTheme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // 요일별 성과
            _buildWeekdayPerformance(),
            const SizedBox(height: 20),

            // 월간 트렌드
            _buildMonthlyTrend(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekdayPerformance() {
    final weekdayData = [
      ('Mon', 145, 2),
      ('Tue', -88, 1),
      ('Wed', 234, 3),
      ('Thu', 67, 1),
      ('Fri', 289, 2),
      ('Sat', 0, 0),
      ('Sun', 86, 1),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance by Weekday',
          style: GoogleFonts.montserrat(
            color: AppTheme.primaryText,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: weekdayData.map((data) {
            final (day, pnl, trades) = data;
            final isPositive = pnl >= 0;

            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isPositive
                      ? AppTheme.positiveColor.withOpacity(0.1)
                      : pnl < 0
                      ? AppTheme.negativeColor.withOpacity(0.1)
                      : AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isPositive
                        ? AppTheme.positiveColor.withOpacity(0.3)
                        : pnl < 0
                        ? AppTheme.negativeColor.withOpacity(0.3)
                        : AppTheme.borderColor,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      day,
                      style: GoogleFonts.montserrat(
                        color: AppTheme.secondaryText,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pnl == 0 ? '-' : '\$${pnl.abs()}',
                      style: GoogleFonts.robotoMono(
                        color: isPositive
                            ? AppTheme.positiveColor
                            : pnl < 0
                            ? AppTheme.negativeColor
                            : AppTheme.secondaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$trades trades',
                      style: GoogleFonts.montserrat(
                        color: AppTheme.secondaryText,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMonthlyTrend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Trend',
          style: GoogleFonts.montserrat(
            color: AppTheme.primaryText,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            children: [
              _buildTrendRow('Total Trades', '22', Icons.swap_horiz),
              const SizedBox(height: 8),
              _buildTrendRow('Winning Trades', '15', Icons.trending_up),
              const SizedBox(height: 8),
              _buildTrendRow('Losing Trades', '7', Icons.trending_down),
              const SizedBox(height: 8),
              _buildTrendRow('Average Trade', '\$33.32', Icons.calculate),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrendRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.accentColor, size: 16),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.montserrat(
            color: AppTheme.secondaryText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.robotoMono(
            color: AppTheme.primaryText,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
