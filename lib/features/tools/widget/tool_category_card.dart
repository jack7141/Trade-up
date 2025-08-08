import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';
import 'package:trade_up/features/tools/view/tools_screen.dart';

class ToolCategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final List<ToolItem> tools;

  const ToolCategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.tools,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 카테고리 헤더
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.montserrat(
                        color: AppTheme.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
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

          const SizedBox(height: 20),

          // 도구 리스트
          ...tools.map(
            (tool) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildToolItem(context, tool),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolItem(BuildContext context, ToolItem tool) {
    return InkWell(
      onTap: tool.isComingSoon
          ? null
          : () {
              context.go(tool.route);
            },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: tool.isComingSoon
              ? AppTheme.backgroundColor.withOpacity(0.3)
              : AppTheme.backgroundColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: tool.isComingSoon
                ? AppTheme.borderColor.withOpacity(0.3)
                : AppTheme.borderColor.withOpacity(0.5),
          ),
        ),
        child: Row(
          children: [
            // 아이콘
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: tool.isComingSoon
                    ? AppTheme.secondaryText.withOpacity(0.1)
                    : AppTheme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                tool.icon,
                color: tool.isComingSoon
                    ? AppTheme.secondaryText.withOpacity(0.6)
                    : AppTheme.accentColor,
                size: 16,
              ),
            ),

            const SizedBox(width: 12),

            // 텍스트 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          tool.title,
                          style: GoogleFonts.montserrat(
                            color: tool.isComingSoon
                                ? AppTheme.secondaryText.withOpacity(0.7)
                                : AppTheme.primaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (tool.isComingSoon) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryText.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Coming Soon',
                            style: GoogleFonts.montserrat(
                              color: AppTheme.secondaryText,
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tool.description,
                    style: GoogleFonts.montserrat(
                      color: tool.isComingSoon
                          ? AppTheme.secondaryText.withOpacity(0.5)
                          : AppTheme.secondaryText,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // 화살표 아이콘
            if (!tool.isComingSoon)
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.secondaryText.withOpacity(0.5),
                size: 14,
              ),
          ],
        ),
      ),
    );
  }
}
