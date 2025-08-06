import 'package:flutter/material.dart';

// 앱 전체의 디자인 시스템을 정의하는 클래스입니다.
// 색상, 폰트 스타일 등을 한 곳에서 관리하여 일관성을 유지합니다.
class AppTheme {
  // 1. 색상 정의 (Color Palette)
  // 디자인 기획서에 명시된 색상들을 상수로 정의합니다.
  static const Color primaryBackground = Color(0xFF111827);
  static const Color componentBackground = Color(0xFF1F2937);
  static const Color primaryAction = Color(0xFF14B8A6); // Teal
  static const Color positive = Color(0xFF34D399); // Emerald Green
  static const Color negative = Color(0xFFF87171); // Soft Red
  static const Color primaryText = Color(0xFFFFFFFF); // White
  static const Color secondaryText = Color(0xFF9CA3AF); // Light Gray

  // TradeUp 전용 색상
  static const Color tradeUpPrimary = Color(0xFF1E88E5); // Trading Blue
  static const Color tradeUpSurface = Color(0xFFF8F9FA);
  static const Color tradeUpOnSurface = Color(0xFF1A1A1A);

  // 2. ColorScheme 정의
  static ColorScheme get lightColorScheme => ColorScheme.fromSeed(
    seedColor: tradeUpPrimary,
    brightness: Brightness.light,
    surface: tradeUpSurface,
    onSurface: tradeUpOnSurface,
  );

  static ColorScheme get darkColorScheme => ColorScheme.fromSeed(
    seedColor: tradeUpPrimary,
    brightness: Brightness.dark,
  );

  // 3. ThemeData 생성
  // 위에서 정의한 색상과 폰트 스타일을 사용하여 앱 전체에 적용될 테마를 만듭니다.
  static ThemeData getTheme({bool isDark = false}) {
    final colorScheme = isDark ? darkColorScheme : lightColorScheme;

    return ThemeData(
      // ColorScheme 적용
      colorScheme: colorScheme,

      // 기본 폰트 설정 (pubspec.yaml에 Inter 폰트 추가 필요)
      fontFamily: 'Inter',

      // 앱의 기본 밝기 설정
      brightness: isDark ? Brightness.dark : Brightness.light,

      // 모든 화면의 기본 배경색 설정
      scaffoldBackgroundColor: colorScheme.surface,

      // Material 3 사용
      useMaterial3: true,

      // 텍스트 스타일 정의
      textTheme: TextTheme(
        // 화면 제목 등에 사용될 스타일
        displayLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
        // 일반 본문 텍스트 스타일
        bodyMedium: TextStyle(
          fontSize: 15,
          color: colorScheme.onSurface.withOpacity(0.8),
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 13,
          color: colorScheme.onSurface.withOpacity(0.6),
        ),
        // 라벨, 부가 설명 등에 사용될 스타일
        labelMedium: TextStyle(
          fontSize: 14,
          color: colorScheme.onSurface.withOpacity(0.7),
        ),
      ),

      // 아이콘 테마 설정
      iconTheme: IconThemeData(
        color: colorScheme.onSurface.withOpacity(0.7),
        size: 24,
      ),

      // 카드(Card) 위젯의 기본 스타일
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // 앱 바(AppBar) 테마
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
