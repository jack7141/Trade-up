import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';

class MainNavigationScreen extends StatefulWidget {
  static const String routeName = "main";
  final Widget child;

  const MainNavigationScreen({super.key, required this.child});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // TradeUp 앱에 맞는 라우팅
    switch (index) {
      case 0:
        context.go("/dashboard");
        break;
      case 1:
        context.go("/history");
        break;
      case 2:
        // Add Trade는 FloatingActionButton에서 처리
        context.go("/add-trade");
        break;
      case 3:
        context.go("/tools");
        break;
      case 4:
        context.go("/profile");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.accentColor, AppTheme.accentColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => _onTap(2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildBottomAppBar() {
    // 화면 크기에 비례한 값들 계산
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final bottomAppBarHeight = math.max(
      80.0,
      math.min(120.0, screenHeight * 0.12),
    );

    // 화면 너비에 비례한 마진과 공간 계산
    final notchMargin = math.max(6.0, math.min(12.0, screenWidth * 0.02));

    return BottomAppBar(
      color: AppTheme.surfaceColor,
      elevation: 0,
      height: bottomAppBarHeight,
      shape: const CircularNotchedRectangle(),
      notchMargin: notchMargin,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppTheme.borderColor, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              icon: Icons.dashboard_outlined,
              selectedIcon: Icons.dashboard,
              label: 'Dashboard',
              screenWidth: screenWidth,
            ),
            _buildNavItem(
              index: 1,
              icon: Icons.history_outlined,
              selectedIcon: Icons.history,
              label: 'History',
              screenWidth: screenWidth,
            ),
            SizedBox(
              width: math.max(50.0, math.min(80.0, screenWidth * 0.15)),
            ), // FloatingActionButton을 위한 비례 공간
            _buildNavItem(
              index: 3,
              icon: Icons.calculate_outlined,
              selectedIcon: Icons.calculate,
              label: 'Tools',
              screenWidth: screenWidth,
            ),
            _buildNavItem(
              index: 4,
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              label: 'Profile',
              screenWidth: screenWidth,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required double screenWidth,
  }) {
    final isSelected = _selectedIndex == index;

    // 화면 너비에 비례한 패딩과 크기 계산
    final horizontalPadding = math.max(8.0, math.min(16.0, screenWidth * 0.03));
    final verticalPadding = math.max(6.0, math.min(12.0, screenWidth * 0.02));
    final iconPadding = math.max(6.0, math.min(12.0, screenWidth * 0.02));
    final iconSize = math.max(20.0, math.min(28.0, screenWidth * 0.06));
    final borderRadius = math.max(8.0, math.min(16.0, screenWidth * 0.03));
    final textIconSpacing = math.max(2.0, math.min(6.0, screenWidth * 0.01));
    final fontSize = math.max(9.0, math.min(13.0, screenWidth * 0.028));

    return GestureDetector(
      onTap: () => _onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(iconPadding),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.accentColor.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected
                    ? AppTheme.accentColor
                    : AppTheme.secondaryText,
                size: iconSize,
              ),
            ),
            SizedBox(height: textIconSpacing),
            Text(
              label,
              style: GoogleFonts.montserrat(
                color: isSelected
                    ? AppTheme.accentColor
                    : AppTheme.secondaryText,
                fontSize: fontSize,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
