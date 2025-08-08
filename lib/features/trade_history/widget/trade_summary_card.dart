import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';
import 'package:trade_up/l10n/app_localizations.dart';

class TradeSummaryCard extends StatelessWidget {
  const TradeSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              children: [
                Icon(Icons.analytics, color: AppTheme.accentColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.thisMonthSummary,
                  style: GoogleFonts.montserrat(
                    color: AppTheme.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 통계 그리드
            LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 400;

                if (isCompact) {
                  // 모바일: 2x2 그리드
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatItem(
                              l10n.totalTrades,
                              '15',
                              Icons.swap_horiz,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatItem(
                              l10n.winRate,
                              '73.3%',
                              Icons.trending_up,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatItem(
                              l10n.profit,
                              '+\$1,259',
                              Icons.add_circle,
                              AppTheme.positiveColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatItem(
                              l10n.loss,
                              '-\$526',
                              Icons.remove_circle,
                              AppTheme.negativeColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildNetProfitCard(context),
                    ],
                  );
                } else {
                  // 데스크톱: 1행 배치
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatItem(
                              l10n.totalTrades,
                              '15',
                              Icons.swap_horiz,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatItem(
                              l10n.winRate,
                              '73.3%',
                              Icons.trending_up,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatItem(
                              l10n.profit,
                              '+\$1,259',
                              Icons.add_circle,
                              AppTheme.positiveColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatItem(
                              l10n.loss,
                              '-\$526',
                              Icons.remove_circle,
                              AppTheme.negativeColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildNetProfitCard(context),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String title,
    String value,
    IconData icon, [
    Color? color,
  ]) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              color?.withOpacity(0.3) ?? AppTheme.borderColor.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color ?? AppTheme.secondaryText, size: 18),
          const SizedBox(height: 8),
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
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: GoogleFonts.robotoMono(
                color: color ?? AppTheme.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetProfitCard(BuildContext context) {
    const netProfit = 733;
    final isPositive = netProfit >= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isPositive ? AppTheme.positiveColor : AppTheme.negativeColor)
            .withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isPositive ? AppTheme.positiveColor : AppTheme.negativeColor)
              .withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            color: isPositive ? AppTheme.positiveColor : AppTheme.negativeColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.netPnl,
                style: GoogleFonts.montserrat(
                  color: AppTheme.secondaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${isPositive ? '+' : ''}\$${netProfit.abs()}',
                style: GoogleFonts.robotoMono(
                  color: isPositive
                      ? AppTheme.positiveColor
                      : AppTheme.negativeColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isPositive
                  ? AppTheme.positiveColor
                  : AppTheme.negativeColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isPositive
                  ? AppLocalizations.of(context)!.profit
                  : AppLocalizations.of(context)!.loss,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
