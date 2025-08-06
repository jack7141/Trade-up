import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  static const String routeName = '/';
  static const String routePath = '/';
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // --- 1. 헤더 ---
            SliverToBoxAdapter(child: _buildHeader()),

            // --- 2. 총 손익 (Net P/L) ---
            SliverToBoxAdapter(child: _buildNetPlCard()),

            // --- 3. 핵심 성과 지표 (Key Metrics) ---
            SliverToBoxAdapter(child: _buildKeyMetrics()),

            // --- 4. 거래 활동 (Trading Activity) ---
            SliverToBoxAdapter(child: _buildTradingActivity()),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // --- 5. AI 코치 인사이트 ---
            SliverToBoxAdapter(
              child: _buildSectionHeader(title: 'AI Coach Insight'),
            ),
            SliverToBoxAdapter(child: _buildAiInsightCard()),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // --- 6. 최근 매매 기록 ---
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                title: 'Recent Trades',
                actionText: 'View All',
                onActionTap: () {
                  // TODO: 전체 히스토리로 이동
                },
              ),
            ),
            SliverToBoxAdapter(child: _buildRecentTrades()),

            const SliverToBoxAdapter(child: SizedBox(height: 100)), // 하단 여백
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.accentColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'TradeUp',
                style: GoogleFonts.montserrat(
                  color: AppTheme.primaryText,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // --- 수정된 부분: 랭킹 배지와 프로필 아이콘을 함께 배치 ---
          Row(
            children: [
              _RankingBadge(rank: 'Novice', icon: Icons.military_tech_outlined),
              const SizedBox(width: 12),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.borderColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNetPlCard() {
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

  Widget _buildKeyMetrics() {
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

  Widget _buildTradingActivity() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Trader Level',
                  style: GoogleFonts.montserrat(
                    color: AppTheme.secondaryText,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Novice Trader',
                  style: GoogleFonts.montserrat(
                    color: AppTheme.accentColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: 32 / 50, // 32 trades out of 50 for next level
                      minHeight: 8,
                      backgroundColor: AppTheme.borderColor,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.accentColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '32 / 50',
                  style: GoogleFonts.bebasNeue(
                    color: AppTheme.primaryText,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '18 more trades to reach Pro Trader!',
              style: GoogleFonts.montserrat(
                color: AppTheme.secondaryText,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    String? actionText,
    VoidCallback? onActionTap,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              color: AppTheme.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (actionText != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionText,
                style: GoogleFonts.montserrat(
                  color: AppTheme.accentColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAiInsightCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.psychology_outlined,
                  color: AppTheme.accentColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "Today's Coaching",
                  style: GoogleFonts.montserrat(
                    color: AppTheme.accentColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Your win rate with the '#Breakout' strategy is 78%. Keep capitalizing on this pattern.",
              style: GoogleFonts.montserrat(
                color: AppTheme.secondaryText.withOpacity(0.9),
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: 더 많은 인사이트 보기 기능
                },
                child: Text(
                  "Learn More",
                  style: GoogleFonts.montserrat(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTrades() {
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

// --- 신규 위젯: 랭킹 배지 (디자인 수정) ---
class _RankingBadge extends StatelessWidget {
  final String rank;
  final IconData icon;

  const _RankingBadge({required this.rank, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentColor.withOpacity(0.15),
            AppTheme.accentColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accentColor.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.accentColor, size: 16),
          const SizedBox(width: 6),
          Text(
            rank,
            style: GoogleFonts.montserrat(
              color: AppTheme.accentColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
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
