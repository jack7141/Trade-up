import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';
import 'package:trade_up/features/profile/widget/profile_header.dart';
import 'package:trade_up/features/profile/widget/profile_stats_card.dart';
import 'package:trade_up/features/profile/widget/profile_menu_section.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 헤더 (사용자 정보)
            const SliverToBoxAdapter(
              child: ProfileHeader(),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // 트레이딩 통계
            const SliverToBoxAdapter(
              child: ProfileStatsCard(),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // 메뉴 섹션들
            SliverToBoxAdapter(
              child: ProfileMenuSection(
                title: 'Account',
                items: [
                  ProfileMenuItem(
                    icon: Icons.person_outline,
                    title: 'Personal Information',
                    subtitle: 'Update your profile details',
                    onTap: () => _showComingSoon(context, 'Personal Information'),
                  ),
                  ProfileMenuItem(
                    icon: Icons.security,
                    title: 'Security',
                    subtitle: 'Password, 2FA, and more',
                    onTap: () => _showComingSoon(context, 'Security Settings'),
                  ),
                  ProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Manage your alerts',
                    onTap: () => _showComingSoon(context, 'Notification Settings'),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            SliverToBoxAdapter(
              child: ProfileMenuSection(
                title: 'Trading',
                items: [
                  ProfileMenuItem(
                    icon: Icons.analytics_outlined,
                    title: 'Trading Preferences',
                    subtitle: 'Risk settings, alerts, and more',
                    onTap: () => _showComingSoon(context, 'Trading Preferences'),
                  ),
                  ProfileMenuItem(
                    icon: Icons.download_outlined,
                    title: 'Export Data',
                    subtitle: 'Download your trading history',
                    onTap: () => _showComingSoon(context, 'Export Data'),
                  ),
                  ProfileMenuItem(
                    icon: Icons.backup_outlined,
                    title: 'Backup & Sync',
                    subtitle: 'Cloud backup settings',
                    onTap: () => _showComingSoon(context, 'Backup Settings'),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            SliverToBoxAdapter(
              child: ProfileMenuSection(
                title: 'Support',
                items: [
                  ProfileMenuItem(
                    icon: Icons.help_outline,
                    title: 'Help Center',
                    subtitle: 'FAQs and guides',
                    onTap: () => _showComingSoon(context, 'Help Center'),
                  ),
                  ProfileMenuItem(
                    icon: Icons.feedback_outlined,
                    title: 'Send Feedback',
                    subtitle: 'Help us improve TradeUp',
                    onTap: () => _showComingSoon(context, 'Send Feedback'),
                  ),
                  ProfileMenuItem(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'Version and legal information',
                    onTap: () => _showAboutDialog(context),
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
                        'Log Out',
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text(
          'Coming Soon',
          style: GoogleFonts.montserrat(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          '$feature is coming in a future update!',
          style: GoogleFonts.montserrat(
            color: AppTheme.secondaryText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
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

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'TradeUp',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.accentColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.trending_up,
          color: Colors.white,
          size: 24,
        ),
      ),
      children: [
        Text(
          'Professional trading journal and analysis tool.',
          style: GoogleFonts.montserrat(
            color: AppTheme.secondaryText,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text(
          'Log Out',
          style: GoogleFonts.montserrat(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: GoogleFonts.montserrat(
            color: AppTheme.secondaryText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
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
              'Log Out',
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
