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

    // Full Calendar Screen에서는 더 큰 크기로 표시
    final isFullCalendarScreen =
        ModalRoute.of(context)?.settings.name == '/full-calendar';
    final dynamicPadding = isFullCalendarScreen
        ? (isCompact ? 12.0 : 16.0)
        : (isCompact ? 16.0 : 20.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isFullCalendarScreen ? 8 : 16),
      child: Container(
        padding: EdgeInsets.all(dynamicPadding),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            _buildHeader(isCompact, isFullCalendarScreen),
            SizedBox(height: isCompact ? 12 : 16),

            // 캘린더와 주간 요약 (반응형) - 공백 제거
            if (isCompact)
              // 모바일: 세로 배치
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCalendar(isCompact, isFullCalendarScreen),
                  if (!isFullCalendarScreen) ...[
                    const SizedBox(height: 8),
                    _buildWeeklySummary(isCompact, isFullCalendarScreen),
                  ],
                ],
              )
            else
              // 데스크톱/태블릿: 가로 배치
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 캘린더 (75%)
                  Expanded(
                    flex: isFullCalendarScreen ? 4 : 3,
                    child: _buildCalendar(isCompact, isFullCalendarScreen),
                  ),
                  if (!isFullCalendarScreen) ...[
                    const SizedBox(width: 20),
                    // 주간 요약 (25%)
                    Expanded(
                      flex: 1,
                      child: _buildWeeklySummary(
                        isCompact,
                        isFullCalendarScreen,
                      ),
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isCompact, [bool isFullCalendarScreen = false]) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isVerySmall = screenWidth < 350;
        final isSmall = screenWidth < 500;

        if (isVerySmall) {
          // 매우 작은 화면: 세로 배치
          return Column(
            children: [
              // 첫 번째 줄: 월 네비게이션
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMonthNavigation(isSmall),
                  _buildThisMonthButton(isSmall),
                ],
              ),
              const SizedBox(height: 8),
              // 두 번째 줄: 월간 통계
              _buildMonthlyStats(isVerySmall: true),
            ],
          );
        } else if (isSmall) {
          // 작은 화면: 축약된 가로 배치
          return Row(
            children: [
              Expanded(flex: 3, child: _buildMonthNavigation(isSmall)),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: _buildThisMonthButton(isSmall)),
              const SizedBox(width: 8),
              Expanded(flex: 3, child: _buildMonthlyStats(isCompact: true)),
            ],
          );
        } else {
          // 일반 화면: 기본 레이아웃
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMonthNavigation(isSmall),
              _buildThisMonthButton(isSmall),
              _buildMonthlyStats(),
            ],
          );
        }
      },
    );
  }

  Widget _buildMonthNavigation(bool isSmall) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
            size: isSmall ? 18 : 20,
          ),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(
            minWidth: isSmall ? 20 : 24,
            minHeight: isSmall ? 20 : 24,
          ),
        ),
        SizedBox(width: isSmall ? 4 : 8),
        Flexible(
          child: Text(
            _getMonthYearString(currentMonth),
            style: GoogleFonts.montserrat(
              color: AppTheme.primaryText,
              fontSize: isSmall ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: isSmall ? 4 : 8),
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
            size: isSmall ? 18 : 20,
          ),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(
            minWidth: isSmall ? 20 : 24,
            minHeight: isSmall ? 20 : 24,
          ),
        ),
      ],
    );
  }

  Widget _buildThisMonthButton(bool isSmall) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 12,
        vertical: isSmall ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
      ),
      child: Text(
        isSmall ? 'Now' : 'This month',
        style: GoogleFonts.montserrat(
          color: AppTheme.accentColor,
          fontSize: isSmall ? 10 : 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMonthlyStats({
    bool isCompact = false,
    bool isVerySmall = false,
  }) {
    if (isVerySmall) {
      // 매우 작은 화면: 한 줄에 압축
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.positiveColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '\$733',
              style: GoogleFonts.robotoMono(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Text(
              '10d',
              style: GoogleFonts.montserrat(
                color: AppTheme.primaryText,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    }

    if (isCompact) {
      // 컴팩트 버전: 라벨 없이
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.positiveColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '\$733',
              style: GoogleFonts.robotoMono(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Text(
              '10d',
              style: GoogleFonts.montserrat(
                color: AppTheme.primaryText,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    }

    // 일반 버전
    return Row(
      mainAxisSize: MainAxisSize.min,
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
    );
  }

  Widget _buildCalendar(bool isCompact, [bool isFullCalendarScreen = false]) {
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
      mainAxisSize: MainAxisSize.min,
      children: [
        // 요일 헤더 - 동적 크기
        LayoutBuilder(
          builder: (context, constraints) {
            final headerFontSize = isFullCalendarScreen
                ? (constraints.maxWidth < 400 ? 11.0 : 13.0)
                : (isCompact ? 10.0 : 12.0);

            return Row(
              children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                  .map(
                    (day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: GoogleFonts.montserrat(
                            color: AppTheme.secondaryText,
                            fontSize: headerFontSize,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
        SizedBox(height: isFullCalendarScreen ? 12 : 8),

        // 캘린더 그리드 - 동적 크기 계산
        LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final cellWidth = (availableWidth - 12) / 7; // 7개 셀, 간격 고려

            // 화면 크기에 따른 동적 높이 계산 - 보수적으로 조정
            double cellHeight;
            if (isFullCalendarScreen) {
              if (availableWidth < 400) {
                cellHeight = cellWidth * 1.0; // 정사각형
              } else if (availableWidth < 600) {
                cellHeight = cellWidth * 0.9; // 약간 직사각형
              } else {
                cellHeight = cellWidth * 0.85; // 직사각형
              }
            } else {
              // 대시보드에서는 더 보수적으로
              if (isCompact) {
                cellHeight = cellWidth * 0.75; // 모바일에서 더 작게
              } else {
                cellHeight = cellWidth * 0.85; // 데스크톱에서도 보수적
              }
            }

            // 최소/최대 높이 제한 - 더 보수적으로
            cellHeight = cellHeight.clamp(
              isFullCalendarScreen ? 55.0 : 35.0, // 최소 높이 감소
              isFullCalendarScreen ? 100.0 : 65.0, // 최대 높이 감소
            );

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(6, (weekIndex) {
                // 빈 주는 건너뛰기
                final weekHasDays = List.generate(7, (dayIndex) {
                  final dayNumber =
                      weekIndex * 7 + dayIndex - firstDayOfWeek + 2;
                  return dayNumber >= 1 && dayNumber <= daysInMonth;
                }).any((hasDay) => hasDay);

                if (!weekHasDays) return const SizedBox.shrink();

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: isFullCalendarScreen ? 3 : 2,
                  ),
                  child: Row(
                    children: List.generate(7, (dayIndex) {
                      final dayNumber =
                          weekIndex * 7 + dayIndex - firstDayOfWeek + 2;

                      if (dayNumber < 1 || dayNumber > daysInMonth) {
                        return Expanded(child: SizedBox(height: cellHeight));
                      }

                      return Expanded(
                        child: _buildCalendarDay(
                          dayNumber,
                          isCompact,
                          isFullCalendarScreen,
                          cellHeight,
                          cellWidth,
                        ),
                      );
                    }),
                  ),
                );
              }).where((widget) => widget is! SizedBox).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCalendarDay(
    int day,
    bool isCompact, [
    bool isFullCalendarScreen = false,
    double? cellHeight,
    double? cellWidth,
  ]) {
    final tradingDay = tradingData[day];

    // 동적 크기 계산
    final height =
        cellHeight ??
        (isFullCalendarScreen ? (isCompact ? 60 : 80) : (isCompact ? 50 : 60));

    // 폰트 크기 동적 계산 - 꽉 찬 느낌
    final dayFontSize = (height * 0.25).clamp(12.0, 20.0);

    // 패딩 동적 계산 - 꽉 찬 느낌
    final dynamicPadding = (height * 0.1).clamp(4.0, 10.0);

    if (tradingDay == null) {
      // 거래 없는 날
      return Container(
        height: height,
        margin: EdgeInsets.all(isFullCalendarScreen ? 1.5 : 0.5),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(isFullCalendarScreen ? 10 : 8),
          border: Border.all(color: AppTheme.borderColor.withOpacity(0.3)),
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.all(dynamicPadding),
            child: Text(
              day.toString(),
              style: GoogleFonts.robotoMono(
                color: AppTheme.secondaryText.withOpacity(0.5),
                fontSize: dayFontSize * 0.9, // 20% 더 크게
                fontWeight: FontWeight.w600,
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
      height: height,
      margin: EdgeInsets.all(isFullCalendarScreen ? 1.5 : 0.5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(isFullCalendarScreen ? 10 : 8),
        boxShadow: isFullCalendarScreen
            ? [
                BoxShadow(
                  color: backgroundColor.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.all(dynamicPadding),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 날짜 - 항상 표시
                Text(
                  day.toString(),
                  style: GoogleFonts.robotoMono(
                    color: Colors.white,
                    fontSize: (availableHeight * 0.35).clamp(16.0, 26.0),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // 남은 공간에 맞춰 정보 표시
                if (availableHeight > 45) ...[
                  // 충분한 공간이 있을 때
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // P&L
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              tradingDay.pnl == 0
                                  ? '\$0'
                                  : '\$${tradingDay.pnl}',
                              style: GoogleFonts.robotoMono(
                                color: Colors.white,
                                fontSize: (availableHeight * 0.32).clamp(
                                  14.0,
                                  22.0,
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),

                        // 거래 수 (공간이 충분할 때만)
                        if (availableHeight > 60)
                          Text(
                            '${tradingDay.trades} trade${tradingDay.trades > 1 ? 's' : ''}',
                            style: GoogleFonts.montserrat(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: (availableHeight * 0.25).clamp(
                                11.0,
                                18.0,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                        // 승률 (공간이 매우 충분할 때만)
                        if (availableHeight > 80 && tradingDay.winRate != null)
                          Text(
                            '${tradingDay.winRate!.toStringAsFixed(0)}%',
                            style: GoogleFonts.montserrat(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: (availableHeight * 0.22).clamp(
                                10.0,
                                16.0,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                          ),
                      ],
                    ),
                  ),
                ] else ...[
                  // 공간이 제한적일 때 - 최소한의 정보만
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // P&L만 표시
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              tradingDay.pnl == 0
                                  ? '\$0'
                                  : (tradingDay.pnl.abs() > 999
                                        ? '\$${(tradingDay.pnl / 1000).toStringAsFixed(1)}k'
                                        : '\$${tradingDay.pnl}'),
                              style: GoogleFonts.robotoMono(
                                color: Colors.white,
                                fontSize: (availableHeight * 0.4).clamp(
                                  12.0,
                                  18.0,
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),

                        // 거래 수를 축약 형태로
                        if (availableHeight > 40)
                          Text(
                            '${tradingDay.trades}T',
                            style: GoogleFonts.montserrat(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: (availableHeight * 0.28).clamp(
                                9.0,
                                15.0,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWeeklySummary(
    bool isCompact, [
    bool isFullCalendarScreen = false,
  ]) {
    final weeks = _calculateWeeklyData();

    return isCompact
        ? SizedBox(
            height: 45, // 더 작은 고정 높이로 overflow 방지
            child: Row(
              children: weeks.asMap().entries.map((entry) {
                final weekIndex = entry.key;
                final weekData = entry.value;

                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 4),
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppTheme.borderColor.withOpacity(0.5),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'W${weekIndex + 1}',
                          style: GoogleFonts.montserrat(
                            color: AppTheme.secondaryText,
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              weekData.pnl >= 0
                                  ? '\$${weekData.pnl}'
                                  : '-\$${weekData.pnl.abs()}',
                              style: GoogleFonts.bebasNeue(
                                color: weekData.pnl >= 0
                                    ? AppTheme.positiveColor
                                    : AppTheme.negativeColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
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
