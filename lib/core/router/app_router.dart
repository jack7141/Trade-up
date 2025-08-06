import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:trade_up/core/view/main_navigation_screen.dart';
import 'package:trade_up/features/dashboard/view/dashboard_screen.dart';

import '../common/exceptions.dart';

// 자동 로그인 체크 함수
Future<String> _checkAutoLogin() async {
  const storage = FlutterSecureStorage();

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://your-api-base-url.com/api', // TODO: 실제 API URL로 변경
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  try {
    final accessToken = await storage.read(key: 'access_token');
    final refreshToken = await storage.read(key: 'refresh_token');
    final userId = await storage.read(key: 'user_id');

    log(
      '🔐 자동 로그인 체크 - Access Token: ${accessToken != null ? '존재' : '없음'}',
      name: 'AutoLogin',
    );
    log(
      '🔐 자동 로그인 체크 - User ID: ${userId != null ? '존재' : '없음'}',
      name: 'AutoLogin',
    );

    // 토큰이 없으면 로그인 화면으로
    if (accessToken == null ||
        accessToken.isEmpty ||
        refreshToken == null ||
        refreshToken.isEmpty) {
      log('❌ 토큰 없음 - 로그인 화면으로 이동', name: 'AutoLogin');
      return "/login";
    }

    // 토큰 유효성 검증
    try {
      final response = await dio.get(
        '/auth/me',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        final userData = response.data;
        log('👤 사용자 정보 조회 성공: $userData', name: 'AutoLogin');

        // 사용자 온보딩 상태 체크 (필요시)
        final isProfileComplete = userData['is_profile_complete'] ?? true;

        if (!isProfileComplete) {
          log('📋 프로필 미완료 - 온보딩 화면으로 이동', name: 'AutoLogin');
          return "/onboarding";
        }

        log('✅ 모든 조건 충족 - 대시보드로 이동', name: 'AutoLogin');
        return "/dashboard";
      } else {
        log('❌ 사용자 정보 조회 실패 - 로그인 화면으로 이동', name: 'AutoLogin');
        return "/login";
      }
    } catch (apiError) {
      log('💥 사용자 정보 조회 에러: $apiError', name: 'AutoLogin', error: apiError);

      // 401 에러인 경우 refresh token으로 재시도
      if (apiError is DioException && apiError.response?.statusCode == 401) {
        try {
          final refreshResponse = await dio.post(
            '/auth/refresh',
            data: {'refresh_token': refreshToken},
          );

          if (refreshResponse.statusCode == 200) {
            // 새 토큰 저장
            final newAccessToken = refreshResponse.data['access_token'];
            await storage.write(key: 'access_token', value: newAccessToken);
            log('🔄 토큰 갱신 성공 - 대시보드로 이동', name: 'AutoLogin');
            return "/dashboard";
          }
        } catch (refreshError) {
          log(
            '💥 토큰 갱신 실패: $refreshError',
            name: 'AutoLogin',
            error: refreshError,
          );
        }
      }

      return "/login";
    }
  } catch (e) {
    log('💥 자동 로그인 체크 에러: $e', name: 'AutoLogin', error: e);
    return "/login";
  }
}

final router = GoRouter(
  initialLocation: '/dashboard',
  onException: handleRouterException,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainNavigationScreen(child: child);
      },
      routes: [
        // Dashboard
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        // History (거래 히스토리)
        GoRoute(
          path: '/history',
          name: 'history',
          builder: (context, state) => const DashboardScreen(),
        ),
        // Add Trade (거래 추가)
        GoRoute(
          path: '/add-trade',
          name: 'add-trade',
          builder: (context, state) => const DashboardScreen(),
        ),
        // Tools (트레이딩 도구)
        GoRoute(
          path: '/tools',
          name: 'tools',
          builder: (context, state) => const DashboardScreen(),
        ),
        // Profile (프로필)
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const DashboardScreen(),
        ),
      ],
    ),
  ],
);
