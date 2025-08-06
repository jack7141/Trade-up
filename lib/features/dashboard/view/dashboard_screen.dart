import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';
import 'package:trade_up/features/dashboard/widget/metric_card.dart';
import 'package:trade_up/features/dashboard/widget/net_pl_card.dart';
import 'package:trade_up/features/dashboard/widget/ranking_badget.dart';
import 'package:trade_up/features/dashboard/widget/recent_trade.dart';
import 'package:trade_up/features/dashboard/widget/trading_activity.dart';

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
            SliverToBoxAdapter(child: NetPlCardWidget()),

            // --- 3. 핵심 성과 지표 (Key Metrics) ---
            SliverToBoxAdapter(child: MetricsWidget()),

            // --- 4. 거래 활동 (Trading Activity) ---
            SliverToBoxAdapter(child: TradingActivityWidget()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // --- 5. 거래 도구(Kelly Simulator) ---
            SliverToBoxAdapter(
              child: _buildSectionHeader(title: 'Trading Tools'),
            ),
            SliverToBoxAdapter(child: _buildTradingTools()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // --- 6. AI 코치 인사이트 ---
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
            SliverToBoxAdapter(child: RecentTradeWidget()),
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
              RankingBadge(rank: 'Novice', icon: Icons.military_tech_outlined),
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

  Widget _buildTradingTools() {
    // 임시 데이터. 실제로는 ViewModel에서 가져와야 합니다.
    const double kellyPercentage = 18.4;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        // onTap: () => _navigateTo(AppScreen.kellySimulator),
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
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentColor.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.insights,
                  color: AppTheme.accentColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Position Sizing',
                      style: GoogleFonts.montserrat(
                        color: AppTheme.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Find your optimal risk per trade.',
                      style: GoogleFonts.montserrat(
                        color: AppTheme.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Optimal Risk',
                    style: GoogleFonts.montserrat(
                      color: AppTheme.secondaryText,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${kellyPercentage.toStringAsFixed(1)}%',
                    style: GoogleFonts.bebasNeue(
                      color: AppTheme.accentColor,
                      fontSize: 22,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
}
