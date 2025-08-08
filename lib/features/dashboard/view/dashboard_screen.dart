import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';
import 'package:trade_up/features/dashboard/widget/daily_pnl_chart_widget.dart';
import 'package:trade_up/features/dashboard/widget/metric_card.dart';
import 'package:trade_up/features/dashboard/widget/net_pl_card.dart';
import 'package:trade_up/features/dashboard/widget/ranking_badget.dart';
import 'package:trade_up/features/dashboard/widget/recent_trade.dart';
import 'package:trade_up/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // --- 1. 헤더 ---
            SliverToBoxAdapter(child: _buildHeader()),
            // 1. 총 손익 (가장 중요)
            SliverToBoxAdapter(child: const NetPlCardWidget()),

            // 2. 핵심 지표
            SliverToBoxAdapter(child: MetricsWidget()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // 고급 기능들은 별도 탭/페이지로 이동
            SliverToBoxAdapter(child: _buildAdvancedFeaturesCard()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // 3. Daily P&L (간단한 차트)
            SliverToBoxAdapter(child: const DailyPnlChartWidget()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // 4. AI 인사이트 (액션 가능한 정보)
            SliverToBoxAdapter(
              child: _buildSectionHeader(title: l10n.aiCoachInsight),
            ),
            SliverToBoxAdapter(child: _buildAiInsightCard()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // 5. 거래 도구 (빠른 액세스)
            SliverToBoxAdapter(child: _buildSectionHeader(title: l10n.tools)),
            SliverToBoxAdapter(child: _buildTradingTools()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // 6. 최근 거래 (축약된 버전)
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                title: l10n.recentTrades,
                actionText: l10n.viewAll,
                onActionTap: () {},
              ),
            ),
            SliverToBoxAdapter(child: const RecentTradeWidget()),
            const SliverToBoxAdapter(child: SizedBox(height: 32)), // 하단 여백
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context)!;

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
              RankingBadge(
                rank: l10n.novice,
                icon: Icons.military_tech_outlined,
              ),
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
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => context.go('/tools'),
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
                      l10n.kellyCriterionCalculator,
                      style: GoogleFonts.montserrat(
                        color: AppTheme.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Optimal position sizing formula.',
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
                    l10n.optimalRisk,
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
    final l10n = AppLocalizations.of(context)!;

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
                  l10n.todaysCoaching,
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
              l10n.breakoutStrategyTip,
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
                  l10n.learnMore,
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

  Widget _buildAdvancedFeaturesCard() {
    final l10n = AppLocalizations.of(context)!;

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
          children: [
            Text(
              l10n.advancedAnalytics,
              style: GoogleFonts.montserrat(
                color: AppTheme.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.exploreDetailedAnalysis,
              style: GoogleFonts.montserrat(
                color: AppTheme.secondaryText,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildFeatureButton(
                    l10n.tradingCalendar,
                    Icons.calendar_month,
                    () {
                      context.push('/full-calendar');
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFeatureButton(
                    l10n.performanceAnalysis,
                    Icons.analytics,
                    () {
                      context.push('/performance-analysis');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButton(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.accentColor, size: 20),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.montserrat(
                color: AppTheme.primaryText,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
