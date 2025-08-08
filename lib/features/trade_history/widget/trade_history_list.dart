import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';
import 'package:trade_up/features/trade_history/model/trade_record.dart';

class TradeHistoryList extends StatelessWidget {
  final String period;
  final String type;
  final String sort;
  final DateTime? customStartDate;
  final DateTime? customEndDate;

  const TradeHistoryList({
    super.key,
    required this.period,
    required this.type,
    required this.sort,
    this.customStartDate,
    this.customEndDate,
  });

  @override
  Widget build(BuildContext context) {
    final filteredTrades = _getFilteredTrades();

    if (filteredTrades.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 리스트 헤더
          Row(
            children: [
              Text(
                'Trade History',
                style: GoogleFonts.montserrat(
                  color: AppTheme.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.accentColor.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  '${filteredTrades.length} trades',
                  style: GoogleFonts.montserrat(
                    color: AppTheme.accentColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 거래 카드들
          ...filteredTrades.map(
            (trade) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildTradeCard(trade),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradeCard(TradeRecord trade) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: trade.isProfit
              ? AppTheme.positiveColor.withOpacity(0.3)
              : trade.pnl < 0
              ? AppTheme.negativeColor.withOpacity(0.3)
              : AppTheme.borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.backgroundColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // TODO: 거래 상세 모달 표시
          _showTradeDetail(trade);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // 상단: 코인 정보 + P&L
            Row(
              children: [
                // 코인 아이콘 + 이름
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getCoinColor(trade.symbol).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getCoinColor(trade.symbol).withOpacity(0.3),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _getCoinSymbol(trade.symbol),
                      style: GoogleFonts.robotoMono(
                        color: _getCoinColor(trade.symbol),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 코인 이름 + 방향
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            trade.symbol,
                            style: GoogleFonts.montserrat(
                              color: AppTheme.primaryText,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: trade.isLong
                                  ? AppTheme.positiveColor
                                  : AppTheme.negativeColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              trade.isLong ? 'Long' : 'Short',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${trade.trades} trade${trade.trades > 1 ? 's' : ''} • ${trade.winRate.toStringAsFixed(1)}% Win Rate',
                        style: GoogleFonts.montserrat(
                          color: AppTheme.secondaryText,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // P&L 금액
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${trade.pnl >= 0 ? '+' : ''}\$${trade.pnl.abs()}',
                      style: GoogleFonts.robotoMono(
                        color: trade.isProfit
                            ? AppTheme.positiveColor
                            : trade.pnl < 0
                            ? AppTheme.negativeColor
                            : AppTheme.secondaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDateTime(trade.dateTime),
                      style: GoogleFonts.robotoMono(
                        color: AppTheme.secondaryText,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // 하단: 추가 정보 (진입/청산 가격 등)
            if (trade.entryPrice != null && trade.exitPrice != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildPriceInfo(
                        'Entry',
                        trade.entryPrice!,
                        AppTheme.secondaryText,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: AppTheme.borderColor,
                    ),
                    Expanded(
                      child: _buildPriceInfo(
                        'Exit',
                        trade.exitPrice!,
                        AppTheme.secondaryText,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: AppTheme.borderColor,
                    ),
                    Expanded(
                      child: _buildPriceInfo(
                        'Size',
                        trade.quantity,
                        AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPriceInfo(String label, dynamic value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            color: color.withOpacity(0.7),
            fontSize: 9,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value is double ? '\$${value.toStringAsFixed(2)}' : value.toString(),
          style: GoogleFonts.robotoMono(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              color: AppTheme.secondaryText.withOpacity(0.5),
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'No trades found',
              style: GoogleFonts.montserrat(
                color: AppTheme.secondaryText,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start recording your first trade!',
              style: GoogleFonts.montserrat(
                color: AppTheme.secondaryText.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TradeRecord> _getFilteredTrades() {
    List<TradeRecord> trades = _dummyTrades;
    final now = DateTime.now();

    // 기간 필터링
    switch (period) {
      case 'Today':
        trades = trades.where((trade) {
          return trade.dateTime.year == now.year &&
              trade.dateTime.month == now.month &&
              trade.dateTime.day == now.day;
        }).toList();
        break;
      case 'This Week':
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 6));
        trades = trades.where((trade) {
          return trade.dateTime.isAfter(
                weekStart.subtract(const Duration(days: 1)),
              ) &&
              trade.dateTime.isBefore(weekEnd.add(const Duration(days: 1)));
        }).toList();
        break;
      case 'This Month':
        trades = trades.where((trade) {
          return trade.dateTime.year == now.year &&
              trade.dateTime.month == now.month;
        }).toList();
        break;
      case 'Last Month':
        final lastMonth = DateTime(now.year, now.month - 1);
        trades = trades.where((trade) {
          return trade.dateTime.year == lastMonth.year &&
              trade.dateTime.month == lastMonth.month;
        }).toList();
        break;
      case '3 Months':
        final threeMonthsAgo = DateTime(now.year, now.month - 3);
        trades = trades.where((trade) {
          return trade.dateTime.isAfter(threeMonthsAgo);
        }).toList();
        break;
      case 'Custom Date':
        if (customStartDate != null && customEndDate != null) {
          trades = trades.where((trade) {
            return trade.dateTime.isAfter(
                  customStartDate!.subtract(const Duration(days: 1)),
                ) &&
                trade.dateTime.isBefore(
                  customEndDate!.add(const Duration(days: 1)),
                );
          }).toList();
        }
        break;
      // 'All'의 경우 모든 거래를 그대로 유지
    }

    // 타입 필터링
    switch (type) {
      case 'Profit Only':
        trades = trades.where((trade) => trade.pnl > 0).toList();
        break;
      case 'Loss Only':
        trades = trades.where((trade) => trade.pnl < 0).toList();
        break;
      case 'Break Even':
        trades = trades.where((trade) => trade.pnl == 0).toList();
        break;
    }

    // 정렬
    switch (sort) {
      case 'Amount (High)':
        trades.sort((a, b) => b.pnl.compareTo(a.pnl));
        break;
      case 'Amount (Low)':
        trades.sort((a, b) => a.pnl.compareTo(b.pnl));
        break;
      case 'Win Rate':
        trades.sort((a, b) => b.winRate.compareTo(a.winRate));
        break;
      default: // 'Date'
        trades.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    }

    return trades;
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Color _getCoinColor(String symbol) {
    switch (symbol) {
      case 'BTC/USDT':
        return const Color(0xFFF7931A);
      case 'ETH/USDT':
        return const Color(0xFF627EEA);
      case 'SOL/USDT':
        return const Color(0xFF9945FF);
      case 'ADA/USDT':
        return const Color(0xFF0033AD);
      default:
        return AppTheme.accentColor;
    }
  }

  String _getCoinSymbol(String symbol) {
    return symbol.split('/')[0].substring(0, 2);
  }

  void _showTradeDetail(TradeRecord trade) {
    // TODO: Phase 2에서 구현
    debugPrint('거래 상세: ${trade.symbol} - \$${trade.pnl}');
  }

  // 더미 데이터 (다양한 기간 포함)
  static final List<TradeRecord> _dummyTrades = [
    // 이번 달 (12월) 데이터
    TradeRecord(
      id: '1',
      symbol: 'BTC/USDT',
      pnl: 511,
      trades: 5,
      winRate: 80.0,
      isLong: true,
      dateTime: DateTime(2024, 12, 7, 14, 30),
      entryPrice: 42500.0,
      exitPrice: 43200.0,
      quantity: 0.1,
    ),
    TradeRecord(
      id: '2',
      symbol: 'ETH/USDT',
      pnl: -288,
      trades: 1,
      winRate: 0.0,
      isLong: false,
      dateTime: DateTime(2024, 12, 3, 9, 15),
      entryPrice: 2850.0,
      exitPrice: 2750.0,
      quantity: 0.5,
    ),
    TradeRecord(
      id: '3',
      symbol: 'SOL/USDT',
      pnl: 321,
      trades: 3,
      winRate: 66.67,
      isLong: true,
      dateTime: DateTime(2024, 12, 14, 16, 45),
      entryPrice: 98.5,
      exitPrice: 105.2,
      quantity: 10.0,
    ),
    TradeRecord(
      id: '4',
      symbol: 'ADA/USDT',
      pnl: -340,
      trades: 2,
      winRate: 0.0,
      isLong: false,
      dateTime: DateTime(2024, 12, 20, 11, 20),
      entryPrice: 0.45,
      exitPrice: 0.38,
      quantity: 1000.0,
    ),
    TradeRecord(
      id: '5',
      symbol: 'BTC/USDT',
      pnl: 101,
      trades: 2,
      winRate: 100.0,
      isLong: true,
      dateTime: DateTime(2024, 12, 21, 8, 10),
      entryPrice: 43000.0,
      exitPrice: 43500.0,
      quantity: 0.05,
    ),
    TradeRecord(
      id: '6',
      symbol: 'SOL/USDT',
      pnl: 427,
      trades: 2,
      winRate: 100.0,
      isLong: true,
      dateTime: DateTime(2024, 12, 27, 13, 55),
      entryPrice: 102.0,
      exitPrice: 108.5,
      quantity: 8.0,
    ),

    // 25년 7월 13일 데이터 (사용자 요청)
    TradeRecord(
      id: '7',
      symbol: 'BTC/USDT',
      pnl: 823,
      trades: 3,
      winRate: 100.0,
      isLong: true,
      dateTime: DateTime(2025, 7, 13, 10, 15),
      entryPrice: 65000.0,
      exitPrice: 66200.0,
      quantity: 0.07,
    ),

    // 지난 달 (11월) 데이터
    TradeRecord(
      id: '8',
      symbol: 'ETH/USDT',
      pnl: -156,
      trades: 2,
      winRate: 50.0,
      isLong: false,
      dateTime: DateTime(2024, 11, 28, 15, 40),
      entryPrice: 3200.0,
      exitPrice: 3120.0,
      quantity: 1.5,
    ),

    // 오늘 데이터
    TradeRecord(
      id: '9',
      symbol: 'SOL/USDT',
      pnl: 245,
      trades: 1,
      winRate: 100.0,
      isLong: true,
      dateTime: DateTime.now().subtract(const Duration(hours: 2)),
      entryPrice: 180.0,
      exitPrice: 185.5,
      quantity: 4.5,
    ),
  ];
}
