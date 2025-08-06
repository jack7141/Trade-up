import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:trade_up/features/dashboard/view/dashboard_screen.dart';

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

    print('🔐 자동 로그인 체크 - Access Token: ${accessToken != null ? '존재' : '없음'}');
    print('🔐 자동 로그인 체크 - User ID: ${userId != null ? '존재' : '없음'}');

    // 토큰이 없으면 로그인 화면으로
    if (accessToken == null ||
        accessToken.isEmpty ||
        refreshToken == null ||
        refreshToken.isEmpty) {
      print('❌ 토큰 없음 - 로그인 화면으로 이동');
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
        print('👤 사용자 정보 조회 성공: $userData');

        // 사용자 온보딩 상태 체크 (필요시)
        final isProfileComplete = userData['is_profile_complete'] ?? true;

        if (!isProfileComplete) {
          print('📋 프로필 미완료 - 온보딩 화면으로 이동');
          return "/onboarding";
        }

        print('✅ 모든 조건 충족 - 대시보드로 이동');
        return "/dashboard";
      } else {
        print('❌ 사용자 정보 조회 실패 - 로그인 화면으로 이동');
        return "/login";
      }
    } catch (apiError) {
      print('💥 사용자 정보 조회 에러: $apiError');

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
            print('🔄 토큰 갱신 성공 - 대시보드로 이동');
            return "/dashboard";
          }
        } catch (refreshError) {
          print('💥 토큰 갱신 실패: $refreshError');
        }
      }

      return "/login";
    }
  } catch (e) {
    print('💥 자동 로그인 체크 에러: $e');
    return "/login";
  }
}

String? _handleException(
  BuildContext context,
  GoRouterState state,
  GoRouter router,
) {
  print('🚨 라우팅 예외 발생: ${state.uri}');
  return null;
}

final router = GoRouter(
  initialLocation: DashboardScreen.routePath,
  onException: _handleException,
  routes: [
    GoRoute(
      path: DashboardScreen.routePath,
      name: DashboardScreen.routeName,
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
);
