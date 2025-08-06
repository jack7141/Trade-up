import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';

class RecentTradeWidget extends StatelessWidget {
  const RecentTradeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _RecentTradeItem(
            symbol: 'BTC/USDT',
            pnl: '+\$84.50',
            isPositive: true,
          ),
          _buildDivider(),
          _RecentTradeItem(
            symbol: 'ETH/USDT',
            pnl: '-\$72.30',
            isPositive: false,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: AppTheme.borderColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
    );
  }
}

// 최근 매매 아이템
class _RecentTradeItem extends StatelessWidget {
  final String symbol;
  final String pnl;
  final bool isPositive;

  const _RecentTradeItem({
    required this.symbol,
    required this.pnl,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? AppTheme.positiveColor : AppTheme.negativeColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            symbol,
            style: GoogleFonts.montserrat(
              color: AppTheme.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            pnl,
            style: GoogleFonts.bebasNeue(
              color: color,
              fontSize: 18,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
