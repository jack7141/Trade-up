import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';
import 'package:trade_up/features/profile/widget/profile_header.dart';
import 'package:trade_up/features/profile/widget/profile_menu_section.dart';
import 'package:trade_up/features/profile/widget/profile_stats_card.dart';
import 'package:trade_up/l10n/app_localizations.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 헤더 (사용자 정보)
            const SliverToBoxAdapter(child: ProfileHeader()),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // 트레이딩 통계
            const SliverToBoxAdapter(child: ProfileStatsCard()),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // 메뉴 섹션들
            SliverToBoxAdapter(
              child: ProfileMenuSection(
                title: l10n.account,
                items: [
                  ProfileMenuItem(
                    icon: Icons.person_outline,
                    title: l10n.personalInformation,
                    subtitle: l10n.updateProfileDetails,
                    onTap: () =>
                        _showComingSoon(context, l10n.personalInformation),
                  ),
                  ProfileMenuItem(
                    icon: Icons.security,
                    title: l10n.security,
                    subtitle: l10n.passwordTwoFactor,
                    onTap: () => _showComingSoon(context, l10n.security),
                  ),
                  ProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    title: l10n.notifications,
                    subtitle: l10n.manageAlerts,
                    onTap: () => _showComingSoon(context, l10n.notifications),
                  ),
                  ProfileMenuItem(
                    icon: Icons.language,
                    title: l10n.language,
                    subtitle: l10n.changeLanguage,
                    onTap: () => context.push('/profile/language'),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            SliverToBoxAdapter(
              child: ProfileMenuSection(
                title: l10n.trading,
                items: [
                  ProfileMenuItem(
                    icon: Icons.analytics_outlined,
                    title: l10n.tradingPreferences,
                    subtitle: l10n.riskSettingsAlerts,
                    onTap: () =>
                        _showComingSoon(context, l10n.tradingPreferences),
                  ),
                  ProfileMenuItem(
                    icon: Icons.download_outlined,
                    title: l10n.exportData,
                    subtitle: l10n.downloadTradingHistory,
                    onTap: () => _showComingSoon(context, l10n.exportData),
                  ),
                  ProfileMenuItem(
                    icon: Icons.backup_outlined,
                    title: l10n.backupSync,
                    subtitle: l10n.cloudBackupSettings,
                    onTap: () => _showComingSoon(context, l10n.backupSync),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            SliverToBoxAdapter(
              child: ProfileMenuSection(
                title: l10n.support,
                items: [
                  ProfileMenuItem(
                    icon: Icons.help_outline,
                    title: l10n.helpCenter,
                    subtitle: l10n.faqsAndGuides,
                    onTap: () => _showComingSoon(context, l10n.helpCenter),
                  ),
                  ProfileMenuItem(
                    icon: Icons.feedback_outlined,
                    title: l10n.sendFeedback,
                    subtitle: l10n.helpUsImprove,
                    onTap: () => _showComingSoon(context, l10n.sendFeedback),
                  ),
                  ProfileMenuItem(
                    icon: Icons.info_outline,
                    title: l10n.about,
                    subtitle: l10n.versionLegalInfo,
                    onTap: () => _showAboutDialog(context, l10n),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // 로그아웃 버튼
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: OutlinedButton(
                  onPressed: () => _showLogoutDialog(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: AppTheme.negativeColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        color: AppTheme.negativeColor,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.logOut,
                        style: GoogleFonts.montserrat(
                          color: AppTheme.negativeColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 하단 여백
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text(
          l10n.comingSoonFeature,
          style: GoogleFonts.montserrat(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          l10n.comingSoonMessage(feature),
          style: GoogleFonts.montserrat(color: AppTheme.secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.ok,
              style: GoogleFonts.montserrat(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context, AppLocalizations l10n) {
    showAboutDialog(
      context: context,
      applicationName: l10n.appTitle,
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.accentColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.trending_up, color: Colors.white, size: 24),
      ),
      children: [
        Text(
          l10n.professionalTradingTool,
          style: GoogleFonts.montserrat(
            color: AppTheme.secondaryText,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text(
          l10n.logOut,
          style: GoogleFonts.montserrat(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          l10n.logOutConfirm,
          style: GoogleFonts.montserrat(color: AppTheme.secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.cancel,
              style: GoogleFonts.montserrat(
                color: AppTheme.secondaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: 실제 로그아웃 로직 구현
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Logout functionality coming soon!',
                    style: GoogleFonts.montserrat(),
                  ),
                  backgroundColor: AppTheme.accentColor,
                ),
              );
            },
            child: Text(
              l10n.logOut,
              style: GoogleFonts.montserrat(
                color: AppTheme.negativeColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileMenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
