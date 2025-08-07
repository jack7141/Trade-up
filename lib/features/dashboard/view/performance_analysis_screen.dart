import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';
import 'package:trade_up/features/dashboard/widget/daily_pnl_chart_widget.dart';
import 'package:trade_up/features/dashboard/widget/zella_score_widget.dart';

class PerformanceAnalysisScreen extends StatefulWidget {
  static const String routeName = 'performance-analysis';
  static const String routePath = '/performance-analysis';

  const PerformanceAnalysisScreen({super.key});

  @override
  State<PerformanceAnalysisScreen> createState() =>
      _PerformanceAnalysisScreenState();
}

class _PerformanceAnalysisScreenState extends State<PerformanceAnalysisScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          'Performance Analysis',
          style: GoogleFonts.montserrat(
            color: AppTheme.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: AppTheme.primaryText),
            onPressed: () {
              // TODO: Share performance report
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Zella Score'),
            Tab(text: 'Performance'),
            Tab(text: 'Risk Analysis'),
          ],
          labelColor: AppTheme.accentColor,
          unselectedLabelColor: AppTheme.secondaryText,
          indicatorColor: AppTheme.accentColor,
          labelStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildZellaScoreTab(),
          _buildPerformanceTab(),
          _buildRiskAnalysisTab(),
        ],
      ),
    );
  }

  Widget _buildZellaScoreTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Zella Score 위젯
            const ZellaScoreWidget(),
            const SizedBox(height: 24),

            // 세부 분석
            _buildScoreBreakdown(),
            const SizedBox(height: 24),

            // 개선 제안
            _buildImprovementSuggestions(),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Daily P&L 차트
            const DailyPnlChartWidget(),
            const SizedBox(height: 24),

            // 성과 지표
            _buildPerformanceMetrics(),
            const SizedBox(height: 24),

            // 월별 비교
            _buildMonthlyComparison(),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskAnalysisTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 리스크 요약
            _buildRiskSummary(),
            const SizedBox(height: 24),

            // 드로다운 분석
            _buildDrawdownAnalysis(),
            const SizedBox(height: 24),

            // 포지션 사이징 분석
            _buildPositionSizingAnalysis(),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBreakdown() {
    final metrics = [
      ('Win Rate', 75.0, 100.0, AppTheme.positiveColor),
      ('Profit Factor', 60.0, 100.0, AppTheme.accentColor),
      ('Avg Win/Loss', 80.0, 100.0, AppTheme.positiveColor),
      ('Recovery Factor', 40.0, 100.0, AppTheme.negativeColor),
      ('Max Drawdown', 70.0, 100.0, AppTheme.accentColor),
      ('Consistency', 50.0, 100.0, AppTheme.negativeColor),
    ];

    return Container(
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
            'Score Breakdown',
            style: GoogleFonts.montserrat(
              color: AppTheme.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          ...metrics.map((metric) {
            final (name, value, max, color) = metric;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.montserrat(
                          color: AppTheme.primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${value.toInt()}/100',
                        style: GoogleFonts.robotoMono(
                          color: color,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: value / max,
                    backgroundColor: AppTheme.backgroundColor,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 6,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildImprovementSuggestions() {
    final suggestions = [
      (
        '🎯',
        'Improve Recovery Factor',
        'Focus on reducing drawdown periods and faster recovery',
      ),
      (
        '📈',
        'Enhance Consistency',
        'Work on maintaining steady performance across different market conditions',
      ),
      (
        '⚖️',
        'Optimize Position Sizing',
        'Consider using Kelly Criterion for better risk management',
      ),
    ];

    return Container(
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
            'Improvement Suggestions',
            style: GoogleFonts.montserrat(
              color: AppTheme.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          ...suggestions.map((suggestion) {
            final (emoji, title, description) = suggestion;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.montserrat(
                            color: AppTheme.primaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: GoogleFonts.montserrat(
                            color: AppTheme.secondaryText,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    return Container(
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
            'Key Performance Metrics',
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
                child: _buildMetricCard(
                  'Total Return',
                  '+15.2%',
                  AppTheme.positiveColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Sharpe Ratio',
                  '1.34',
                  AppTheme.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Max Drawdown',
                  '-8.5%',
                  AppTheme.negativeColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Profit Factor',
                  '1.85',
                  AppTheme.positiveColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.bebasNeue(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyComparison() {
    final months = ['Dec', 'Jan', 'Feb'];
    final returns = [8.5, -2.1, 15.2];

    return Container(
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
            'Monthly Comparison',
            style: GoogleFonts.montserrat(
              color: AppTheme.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: months.asMap().entries.map((entry) {
              final index = entry.key;
              final month = entry.value;
              final returnValue = returns[index];
              final isPositive = returnValue >= 0;

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isPositive
                          ? AppTheme.positiveColor.withOpacity(0.3)
                          : AppTheme.negativeColor.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        month,
                        style: GoogleFonts.montserrat(
                          color: AppTheme.secondaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${isPositive ? '+' : ''}${returnValue.toStringAsFixed(1)}%',
                        style: GoogleFonts.robotoMono(
                          color: isPositive
                              ? AppTheme.positiveColor
                              : AppTheme.negativeColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.negativeColor.withOpacity(0.05),
            AppTheme.surfaceColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.negativeColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_outlined,
                color: AppTheme.negativeColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Risk Assessment',
                style: GoogleFonts.montserrat(
                  color: AppTheme.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildRiskItem(
            'Value at Risk (95%)',
            '-\$245',
            'Maximum expected loss in 1 day',
          ),
          const SizedBox(height: 12),
          _buildRiskItem(
            'Portfolio Beta',
            '1.15',
            'Sensitivity to market movements',
          ),
          const SizedBox(height: 12),
          _buildRiskItem(
            'Risk Score',
            'Medium',
            'Overall risk level assessment',
          ),
        ],
      ),
    );
  }

  Widget _buildRiskItem(String title, String value, String description) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.montserrat(
                  color: AppTheme.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: GoogleFonts.montserrat(
                  color: AppTheme.secondaryText,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.robotoMono(
            color: AppTheme.negativeColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDrawdownAnalysis() {
    return Container(
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
            'Drawdown Analysis',
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
                child: _buildDrawdownCard(
                  'Current',
                  '-2.1%',
                  AppTheme.accentColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDrawdownCard(
                  'Maximum',
                  '-8.5%',
                  AppTheme.negativeColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDrawdownCard(
                  'Recovery',
                  '12 days',
                  AppTheme.positiveColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawdownCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
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
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.robotoMono(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionSizingAnalysis() {
    return Container(
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
            'Position Sizing Analysis',
            style: GoogleFonts.montserrat(
              color: AppTheme.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          _buildSizingMetric('Average Position Size', '2.5%', 'of portfolio'),
          const SizedBox(height: 12),
          _buildSizingMetric('Largest Position', '5.2%', 'of portfolio'),
          const SizedBox(height: 12),
          _buildSizingMetric('Kelly Criterion', '18.4%', 'optimal size'),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: AppTheme.accentColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Consider increasing position sizes based on Kelly Criterion for optimal growth',
                    style: GoogleFonts.montserrat(
                      color: AppTheme.accentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizingMetric(String title, String value, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.montserrat(
                color: AppTheme.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.montserrat(
                color: AppTheme.secondaryText,
                fontSize: 11,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: GoogleFonts.robotoMono(
            color: AppTheme.accentColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
