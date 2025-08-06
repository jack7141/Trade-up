import 'package:flutter/material.dart';

// 앱 전체의 디자인 시스템을 정의하는 클래스입니다.
// 색상, 폰트 스타일 등을 한 곳에서 관리하여 일관성을 유지합니다.
class AppTheme {
  // === TradeUp Bybit 스타일 색상 팔레트 ===

  // 배경 색상들
  static const Color backgroundColor = Color(0xFF0D0D0D); // 메인 배경 (거의 검정)
  static const Color surfaceColor = Color(0xFF1A1A1A); // 카드/컨테이너 배경
  static const Color borderColor = Color(0xFF2B3139); // 경계선/구분선

  // 텍스트 색상들
  static const Color primaryText = Color(0xFFFFFFFF); // 주요 텍스트 (흰색)
  static const Color secondaryText = Color(0xFF848E9C); // 보조 텍스트 (회색)

  // 기능적 색상들
  static const Color accentColor = Color(0xFFF7931A); // 브랜드/액션 (Bitcoin 오렌지)
  static const Color positiveColor = Color(0xFF0ECB81); // 수익/상승 (녹색)
  static const Color negativeColor = Color(0xFFF23645); // 손실/하락 (빨간색)

  // 기존 색상들 (하위 호환성을 위해 유지, 점진적 제거 예정)
  @deprecated
  static const Color primaryBackground = backgroundColor;
  @deprecated
  static const Color componentBackground = surfaceColor;
  @deprecated
  static const Color primaryAction = accentColor;
  @deprecated
  static const Color positive = positiveColor;
  @deprecated
  static const Color negative = negativeColor;

  // ColorScheme 정의
  static ColorScheme get lightColorScheme => ColorScheme.fromSeed(
    seedColor: accentColor,
    brightness: Brightness.light,
    surface: const Color(0xFFF8F9FA),
    onSurface: backgroundColor,
  );

  static ColorScheme get darkColorScheme => ColorScheme.fromSeed(
    seedColor: accentColor,
    brightness: Brightness.dark,
    surface: surfaceColor, // 카드/컨테이너 배경
    onSurface: primaryText, // surface 위의 텍스트
    background: backgroundColor, // Scaffold 배경
    onBackground: primaryText, // background 위의 텍스트
    primary: accentColor, // 주요 액션 색상
    onPrimary: primaryText, // primary 위의 텍스트
    outline: borderColor, // 경계선
    secondary: secondaryText, // 보조 텍스트용
  );

  // ThemeData 생성
  static ThemeData getTheme({bool isDark = true}) {
    final colorScheme = isDark ? darkColorScheme : lightColorScheme;

    return ThemeData(
      // ColorScheme 적용
      colorScheme: colorScheme,

      // 기본 폰트 설정
      fontFamily: 'Inter',

      // 앱의 기본 밝기 설정
      brightness: isDark ? Brightness.dark : Brightness.light,

      // 모든 화면의 기본 배경색 설정
      scaffoldBackgroundColor: isDark
          ? backgroundColor
          : const Color(0xFFFFFFFF),

      // Material 3 사용
      useMaterial3: true,

      // 텍스트 스타일 정의
      textTheme: TextTheme(
        // 큰 제목
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: isDark ? primaryText : const Color(0xFF1A1A1A),
        ),
        // 화면 제목
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: isDark ? primaryText : const Color(0xFF1A1A1A),
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: isDark ? primaryText : const Color(0xFF1A1A1A),
        ),
        // 섹션 제목
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: isDark ? primaryText : const Color(0xFF1A1A1A),
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: isDark ? primaryText : const Color(0xFF1A1A1A),
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDark ? primaryText : const Color(0xFF1A1A1A),
        ),
        // 본문 텍스트
        bodyLarge: TextStyle(
          fontSize: 16,
          color: isDark ? primaryText : const Color(0xFF1A1A1A),
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: isDark ? secondaryText : const Color(0xFF6B7280),
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: isDark ? secondaryText : const Color(0xFF6B7280),
        ),
        // 라벨 텍스트
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDark ? primaryText : const Color(0xFF1A1A1A),
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isDark ? secondaryText : const Color(0xFF6B7280),
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: isDark ? secondaryText : const Color(0xFF6B7280),
        ),
      ),

      // 아이콘 테마 설정
      iconTheme: IconThemeData(
        color: isDark ? secondaryText : const Color(0xFF6B7280),
        size: 24,
      ),

      // 카드(Card) 위젯의 기본 스타일
      cardTheme: CardThemeData(
        color: isDark ? surfaceColor : const Color(0xFFFFFFFF),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDark ? borderColor : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),

      // 앱 바(AppBar) 테마
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? backgroundColor : const Color(0xFFFFFFFF),
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(
          color: isDark ? primaryText : const Color(0xFF1A1A1A),
        ),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isDark ? primaryText : const Color(0xFF1A1A1A),
          fontFamily: 'Inter',
        ),
      ),

      // 버튼 테마들
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: primaryText,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? primaryText : const Color(0xFF1A1A1A),
          side: BorderSide(
            color: isDark ? borderColor : const Color(0xFFE5E7EB),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      // 입력 필드 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? surfaceColor : const Color(0xFFF9FAFB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? borderColor : const Color(0xFFE5E7EB),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? borderColor : const Color(0xFFE5E7EB),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: accentColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: negativeColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        hintStyle: TextStyle(
          color: isDark ? secondaryText : const Color(0xFF9CA3AF),
        ),
      ),

      // Divider 테마
      dividerTheme: DividerThemeData(
        color: isDark ? borderColor : const Color(0xFFE5E7EB),
        thickness: 1,
        space: 1,
      ),
    );
  }
}
