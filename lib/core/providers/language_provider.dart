import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('en') {
    _loadLanguage();
  }

  static const String _languageKey = 'selected_language';

  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey);
      if (savedLanguage != null) {
        state = savedLanguage;
      } else {
        // 시스템 언어 감지
        final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
        final systemLanguage = systemLocale.languageCode;

        // 지원하는 언어인지 확인
        const supportedLanguages = ['en', 'vi', 'ko'];
        if (supportedLanguages.contains(systemLanguage)) {
          state = systemLanguage;
          await _saveLanguage(systemLanguage);
        } else {
          state = 'en'; // 기본값
          await _saveLanguage('en');
        }
      }
    } catch (e) {
      state = 'en'; // 오류 시 기본값
    }
  }

  Future<void> setLanguage(String languageCode) async {
    state = languageCode;
    await _saveLanguage(languageCode);
  }

  Future<void> _saveLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
    } catch (e) {
      // 저장 실패 시 무시 (앱 재시작 시 기본값으로 돌아감)
    }
  }

  Locale get locale => Locale(state);

  String get languageName {
    switch (state) {
      case 'ko':
        return '한국어';
      case 'vi':
        return 'Tiếng Việt';
      case 'en':
      default:
        return 'English';
    }
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
});
