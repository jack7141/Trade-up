import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// GoRouter에서 발생하는 예외를 처리하는 핸들러
String? handleRouterException(
  BuildContext context,
  GoRouterState state,
  GoRouter router,
) {
  log('🚨 라우팅 예외 발생: ${state.uri}', name: 'RouterException');
  // 특정 경로나 에러에 대한 처리 로직을 여기에 추가할 수 있습니다
  // 예: OAuth 관련 에러 무시, 404 페이지로 리다이렉트 등
  if (state.uri.path.startsWith('/unknown') || state.uri.path.isEmpty) {
    return '/dashboard';
  }

  return null;
}

/// API 호출 시 발생하는 예외를 처리하는 클래스들
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, String>? fieldErrors;

  const ValidationException(this.message, {this.fieldErrors});

  @override
  String toString() => 'ValidationException: $message';
}
