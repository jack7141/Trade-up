import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';

class TradingCalendarWidget extends StatefulWidget {
  const TradingCalendarWidget({super.key});

  @override
  State<TradingCalendarWidget> createState() => _TradingCalendarWidgetState();
}

class _TradingCalendarWidgetState extends State<TradingCalendarWidget> {
  DateTime currentMonth = DateTime(2025, 2); // February 2025

  // 더미 데이터
  final Map<int, TradingDay> tradingData = {
    2: TradingDay(pnl: 0, trades: 1, isProfit: false),
    3: TradingDay(pnl: -288, trades: 1, isProfit: false),
    4: TradingDay(pnl: 0, trades: 3, isProfit: false),
    7: TradingDay(pnl: 511, trades: 5, isProfit: true, winRate: 80.0),
    13: TradingDay(pnl: 0, trades: 1, isProfit: false),
    14: TradingDay(pnl: 321, trades: 3, isProfit: true, winRate: 66.67),
    18: TradingDay(pnl: 0, trades: 2, isProfit: false),
    20: TradingDay(pnl: -340, trades: 2, isProfit: false),
    21: TradingDay(pnl: 101, trades: 2, isProfit: true, winRate: 100.0),
    27: TradingDay(pnl: 427, trades: 2, isProfit: true, winRate: 100.0),
  };

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 800;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: EdgeInsets.all(isCompact ? 16 : 20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppTheme.backgroundColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // 헤더
            _buildHeader(isCompact),
            SizedBox(height: isCompact ? 16 : 20),

            // 캘린더와 주간 요약 (반응형)
            if (isCompact)
              // 모바일: 세로 배치
              Column(
                children: [
                  _buildCalendar(isCompact),
                  const SizedBox(height: 16),
                  _buildWeeklySummary(isCompact),
                ],
              )
            else
              // 데스크톱/태블릿: 가로 배치
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 캘린더 (75%)
                  Expanded(flex: 3, child: _buildCalendar(isCompact)),
                  const SizedBox(width: 20),

                  // 주간 요약 (25%)
                  Expanded(flex: 1, child: _buildWeeklySummary(isCompact)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isCompact) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 월 네비게이션
        Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  currentMonth = DateTime(
                    currentMonth.year,
                    currentMonth.month - 1,
                  );
                });
              },
              icon: Icon(
                Icons.chevron_left,
                color: AppTheme.secondaryText,
                size: 20,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            ),
            const SizedBox(width: 8),
            Text(
              _getMonthYearString(currentMonth),
              style: GoogleFonts.montserrat(
                color: AppTheme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                setState(() {
                  currentMonth = DateTime(
                    currentMonth.year,
                    currentMonth.month + 1,
                  );
                });
              },
              icon: Icon(
                Icons.chevron_right,
                color: AppTheme.secondaryText,
                size: 20,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            ),
          ],
        ),

        // 현재 월 버튼
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
          ),
          child: Text(
            'This month',
            style: GoogleFonts.montserrat(
              color: AppTheme.accentColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // 월간 통계
        Row(
          children: [
            Text(
              'Monthly stats:',
              style: GoogleFonts.montserrat(
                color: AppTheme.secondaryText,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.positiveColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '\$733',
                style: GoogleFonts.robotoMono(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: Text(
                '10 days',
                style: GoogleFonts.montserrat(
                  color: AppTheme.primaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendar(bool isCompact) {
    final daysInMonth = DateTime(
      currentMonth.year,
      currentMonth.month + 1,
      0,
    ).day;
    final firstDayOfWeek = DateTime(
      currentMonth.year,
      currentMonth.month,
      1,
    ).weekday;

    return Column(
      children: [
        // 요일 헤더
        Row(
          children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: GoogleFonts.montserrat(
                        color: AppTheme.secondaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),

        // 캘린더 그리드
        ...List.generate(6, (weekIndex) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: List.generate(7, (dayIndex) {
                final dayNumber = weekIndex * 7 + dayIndex - firstDayOfWeek + 2;

                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return Expanded(child: SizedBox(height: isCompact ? 50 : 60));
                }

                return Expanded(child: _buildCalendarDay(dayNumber, isCompact));
              }),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCalendarDay(int day, bool isCompact) {
    final tradingDay = tradingData[day];

    if (tradingDay == null) {
      // 거래 없는 날
      return Container(
        height: isCompact ? 50 : 60,
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.borderColor.withOpacity(0.3)),
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              day.toString(),
              style: GoogleFonts.robotoMono(
                color: AppTheme.secondaryText.withOpacity(0.5),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    // 거래 있는 날
    Color backgroundColor;
    if (tradingDay.pnl > 0) {
      backgroundColor = AppTheme.positiveColor.withOpacity(0.8);
    } else if (tradingDay.pnl < 0) {
      backgroundColor = AppTheme.negativeColor.withOpacity(0.8);
    } else {
      backgroundColor = Colors.blue.withOpacity(0.8);
    }

    return Container(
      height: isCompact ? 50 : 60,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜
            Text(
              day.toString(),
              style: GoogleFonts.robotoMono(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),

            // P&L
            Text(
              tradingDay.pnl == 0 ? '\$0' : '\$${tradingDay.pnl}',
              style: GoogleFonts.robotoMono(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),

            // 거래 수
            Text(
              '${tradingDay.trades} trade${tradingDay.trades > 1 ? 's' : ''}',
              style: GoogleFonts.montserrat(
                color: Colors.white.withOpacity(0.9),
                fontSize: 8,
                fontWeight: FontWeight.w500,
              ),
            ),

            // 승률 (있는 경우)
            if (tradingDay.winRate != null)
              Text(
                '${tradingDay.winRate!.toStringAsFixed(0)}%',
                style: GoogleFonts.montserrat(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklySummary(bool isCompact) {
    final weeks = _calculateWeeklyData();

    return isCompact
        ? Row(
            children: weeks.asMap().entries.map((entry) {
              final weekIndex = entry.key;
              final weekData = entry.value;

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.borderColor.withOpacity(0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'W${weekIndex + 1}',
                        style: GoogleFonts.montserrat(
                          color: AppTheme.secondaryText,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        weekData.pnl >= 0
                            ? '\$${weekData.pnl}'
                            : '-\$${weekData.pnl.abs()}',
                        style: GoogleFonts.bebasNeue(
                          color: weekData.pnl >= 0
                              ? AppTheme.positiveColor
                              : AppTheme.negativeColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          )
        : Column(
            children: weeks.asMap().entries.map((entry) {
              final weekIndex = entry.key;
              final weekData = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.borderColor.withOpacity(0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Week ${weekIndex + 1}',
                      style: GoogleFonts.montserrat(
                        color: AppTheme.secondaryText,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      weekData.pnl >= 0
                          ? '\$${weekData.pnl}'
                          : '-\$${weekData.pnl.abs()}',
                      style: GoogleFonts.bebasNeue(
                        color: weekData.pnl >= 0
                            ? AppTheme.positiveColor
                            : AppTheme.negativeColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${weekData.days} day${weekData.days > 1 ? 's' : ''}',
                      style: GoogleFonts.montserrat(
                        color: AppTheme.accentColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
  }

  String _getMonthYearString(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  List<WeeklyData> _calculateWeeklyData() {
    // 간단한 주간 데이터 계산 (실제로는 더 정교한 로직 필요)
    return [
      WeeklyData(pnl: 0, days: 0),
      WeeklyData(pnl: 223, days: 4),
      WeeklyData(pnl: 321, days: 2),
      WeeklyData(pnl: -238, days: 3),
      WeeklyData(pnl: 427, days: 1),
    ];
  }
}

class TradingDay {
  final int pnl;
  final int trades;
  final bool isProfit;
  final double? winRate;

  TradingDay({
    required this.pnl,
    required this.trades,
    required this.isProfit,
    this.winRate,
  });
}

class WeeklyData {
  final int pnl;
  final int days;

  WeeklyData({required this.pnl, required this.days});
}
