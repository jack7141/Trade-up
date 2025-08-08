import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';
import 'package:trade_up/features/tools/widget/tool_category_card.dart';
import 'package:trade_up/l10n/app_localizations.dart';

class ToolsScreen extends ConsumerWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 헤더
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.tools,
                      style: GoogleFonts.montserrat(
                        color: AppTheme.primaryText,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Professional trading calculators and analysis tools',
                      style: GoogleFonts.montserrat(
                        color: AppTheme.secondaryText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 계산기 도구들
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ToolCategoryCard(
                  title: l10n.calculators,
                  subtitle: 'Essential trading calculation tools',
                  icon: Icons.calculate,
                  iconColor: AppTheme.accentColor,
                  tools: [
                    ToolItem(
                      title: l10n.kellyCriterionCalculator,
                      description:
                          'Calculate optimal position size using Kelly formula',
                      icon: Icons.psychology,
                      route: '/tools/kelly-criterion',
                    ),
                    ToolItem(
                      title: l10n.positionSizeCalculator,
                      description:
                          'Calculate optimal position size based on risk',
                      icon: Icons.pie_chart,
                      route: '/tools/position-size',
                    ),
                    ToolItem(
                      title: l10n.profitLossCalculator,
                      description: 'Calculate potential profits and losses',
                      icon: Icons.trending_up,
                      route: '/tools/profit-loss',
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Portfolio Management (Coming Soon)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ToolCategoryCard(
                  title: l10n.portfolioManagement,
                  subtitle: '${l10n.comingSoon} - Advanced portfolio tools',
                  icon: Icons.folder,
                  iconColor: AppTheme.secondaryText,
                  tools: const [
                    ToolItem(
                      title: 'Portfolio Tracker',
                      description: 'Track your portfolio performance',
                      icon: Icons.track_changes,
                      route: '/tools/portfolio',
                      isComingSoon: true,
                    ),
                    ToolItem(
                      title: 'Performance Analytics',
                      description: 'Detailed performance analysis',
                      icon: Icons.bar_chart,
                      route: '/tools/analytics',
                      isComingSoon: true,
                    ),
                    ToolItem(
                      title: 'Risk Assessment',
                      description: 'Portfolio risk analysis',
                      icon: Icons.shield_outlined,
                      route: '/tools/risk-assessment',
                      isComingSoon: true,
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Market Analysis (Coming Soon)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ToolCategoryCard(
                  title: l10n.marketAnalysis,
                  subtitle: '${l10n.comingSoon} - Market insights & data',
                  icon: Icons.analytics,
                  iconColor: AppTheme.secondaryText,
                  tools: const [
                    ToolItem(
                      title: 'Fear & Greed Index',
                      description: 'Market sentiment indicator',
                      icon: Icons.psychology,
                      route: '/tools/fear-greed',
                      isComingSoon: true,
                    ),
                    ToolItem(
                      title: 'Crypto News Feed',
                      description: 'Latest cryptocurrency news',
                      icon: Icons.newspaper,
                      route: '/tools/news',
                      isComingSoon: true,
                    ),
                  ],
                ),
              ),
            ),

            // 하단 여백 (넉넉하게)
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class ToolItem {
  final String title;
  final String description;
  final IconData icon;
  final String route;
  final bool isComingSoon;

  const ToolItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    this.isComingSoon = false,
  });
}
