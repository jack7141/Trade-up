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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // --- 1. 헤더 영역 ---
            SliverToBoxAdapter(child: _buildHeader()),

            // --- 2. 총 자산 카드 ---
            SliverToBoxAdapter(child: _buildTotalAssetsCard()),

            // --- 3. 빠른 액세스 메뉴 ---
            SliverToBoxAdapter(child: _buildQuickAccessMenu()),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // --- 4. 시장 개요 ---
            SliverToBoxAdapter(child: _buildSectionHeader(title: '시장 개요')),
            SliverToBoxAdapter(child: _buildMarketOverview()),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // --- 5. 내 거래 현황 ---
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                title: '내 거래 현황',
                actionText: '전체보기',
                onActionTap: () {
                  // TODO: 전체 히스토리로 이동
                },
              ),
            ),
            SliverToBoxAdapter(child: _buildMyTradesStatus()),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  // --- 위젯 빌더 함수들 ---

  Widget _buildHeader() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                  color: colorScheme.primary,
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
                style: GoogleFonts.poppins(
                  color: colorScheme.onSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildIconButton(Icons.qr_code_scanner),
              const SizedBox(width: 12),
              _buildIconButton(Icons.notifications_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalAssetsCard() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outline, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '총 자산 (USDT)',
                  style: GoogleFonts.poppins(
                    color: colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.visibility_off_outlined,
                  color: colorScheme.onSurface.withOpacity(0.7),
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '12,450.67',
                  style: GoogleFonts.inter(
                    color: colorScheme.onSurface,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.positiveColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '+24.5%',
                    style: GoogleFonts.inter(
                      color: AppTheme.positiveColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '≈ \$12,450.67',
              style: GoogleFonts.inter(
                color: colorScheme.onSurface.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(text: '입금', isPrimary: true),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(text: '출금', isPrimary: false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _QuickAccessItem(icon: Icons.swap_horiz, label: '거래'),
          _QuickAccessItem(icon: Icons.psychology_outlined, label: 'AI 분석'),
          _QuickAccessItem(icon: Icons.copy_outlined, label: '카피트레이딩'),
          _QuickAccessItem(icon: Icons.school_outlined, label: '학습'),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    String? actionText,
    VoidCallback? onActionTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              color: colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (actionText != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionText,
                style: GoogleFonts.inter(
                  color: colorScheme.primary,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMarketOverview() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outline, width: 1),
        ),
        child: Column(
          children: [
            _MarketItem(
              symbol: 'BTC/USDT',
              price: '43,250.67',
              change: '+2.45%',
              isPositive: true,
            ),
            _buildDivider(),
            _MarketItem(
              symbol: 'ETH/USDT',
              price: '2,650.89',
              change: '+1.23%',
              isPositive: true,
            ),
            _buildDivider(),
            _MarketItem(
              symbol: 'BNB/USDT',
              price: '315.42',
              change: '-0.87%',
              isPositive: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyTradesStatus() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outline, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: _StatsItem(
                title: '오늘 손익',
                value: '+\$245.67',
                color: AppTheme.positiveColor,
              ),
            ),
            Container(width: 1, height: 40, color: colorScheme.outline),
            Expanded(
              child: _StatsItem(
                title: '총 손익',
                value: '+\$1,234.56',
                color: AppTheme.positiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 공통 위젯들 ---

  Widget _buildIconButton(IconData icon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outline, width: 1),
      ),
      child: Icon(
        icon,
        color: colorScheme.onSurface.withOpacity(0.7),
        size: 20,
      ),
    );
  }

  Widget _buildActionButton({required String text, required bool isPrimary}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isPrimary ? colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isPrimary
            ? null
            : Border.all(color: colorScheme.onSurface.withOpacity(0.7)),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.inter(
            color: isPrimary
                ? colorScheme.onPrimary
                : colorScheme.onSurface.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 1,
      color: colorScheme.outline,
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}

// 빠른 액세스 아이템
class _QuickAccessItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickAccessItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            color: colorScheme.onSurface.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// 마켓 아이템
class _MarketItem extends StatelessWidget {
  final String symbol;
  final String price;
  final String change;
  final bool isPositive;

  const _MarketItem({
    required this.symbol,
    required this.price,
    required this.change,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = isPositive ? AppTheme.positiveColor : AppTheme.negativeColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            symbol,
            style: GoogleFonts.ibmPlexMono(
              color: colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            price,
            style: GoogleFonts.inter(
              color: colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 80,
            alignment: Alignment.centerRight,
            child: Text(
              change,
              style: GoogleFonts.inter(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 통계 아이템
class _StatsItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatsItem({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            color: colorScheme.onSurface.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.inter(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
