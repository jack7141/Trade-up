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
                    // 캘린더를 LayoutBuilder로 감싸서 크기 최적화
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final screenHeight = MediaQuery.of(context).size.height;
                        final maxHeight = screenHeight < 700
                            ? screenHeight *
                                  0.5 // 작은 화면에서는 50%
                            : screenHeight * 0.6; // 큰 화면에서는 60%

                        return Container(
                          constraints: BoxConstraints(
                            maxHeight: maxHeight,
                            minHeight: 300, // 최소 높이 줄임
                          ),
                          child: const TradingCalendarWidget(),
                        );
                      },
                    ),
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

    return LayoutBuilder(
      builder: (context, constraints) {
        // 화면 크기에 따른 동적 크기 계산
        final screenWidth = constraints.maxWidth;
        final isSmallScreen = screenWidth < 600;
        final isMediumScreen = screenWidth >= 600 && screenWidth < 900;

        // 각 카드의 높이 계산
        final cardHeight = isSmallScreen
            ? 80.0
            : isMediumScreen
            ? 90.0
            : 100.0;

        // 폰트 크기 동적 계산
        final dayFontSize = isSmallScreen
            ? 9.0
            : isMediumScreen
            ? 10.0
            : 11.0;
        final pnlFontSize = isSmallScreen
            ? 10.0
            : isMediumScreen
            ? 11.0
            : 12.0;
        final tradesFontSize = isSmallScreen
            ? 7.0
            : isMediumScreen
            ? 8.0
            : 9.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance by Weekday',
              style: GoogleFonts.montserrat(
                color: AppTheme.primaryText,
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // 동적 크기의 요일별 성과 카드들
            SizedBox(
              height: cardHeight,
              child: Row(
                children: weekdayData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final (day, pnl, trades) = entry.value;
                  final isPositive = pnl >= 0;
                  final isLast = index == weekdayData.length - 1;

                  return Expanded(
                    child: Container(
                      height: cardHeight,
                      margin: EdgeInsets.only(
                        right: isLast ? 0 : (isSmallScreen ? 3 : 4),
                      ),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 요일
                          Text(
                            day,
                            style: GoogleFonts.montserrat(
                              color: AppTheme.secondaryText,
                              fontSize: dayFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 2 : 4),

                          // P&L 금액
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                pnl == 0 ? '-' : '\$${pnl.abs()}',
                                style: GoogleFonts.robotoMono(
                                  color: isPositive
                                      ? AppTheme.positiveColor
                                      : pnl < 0
                                      ? AppTheme.negativeColor
                                      : AppTheme.secondaryText,
                                  fontSize: pnlFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),

                          SizedBox(height: isSmallScreen ? 1 : 2),

                          // 거래 수
                          Text(
                            '$trades trade${trades != 1 ? 's' : ''}',
                            style: GoogleFonts.montserrat(
                              color: AppTheme.secondaryText,
                              fontSize: tradesFontSize,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
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
