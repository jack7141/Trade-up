import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trade_up/l10n/app_localizations.dart';

import 'core/providers/language_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(ProviderScope(child: const TradeUpApp()));
}

class TradeUpApp extends ConsumerWidget {
  const TradeUpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(languageProvider);

    return MaterialApp.router(
      title: 'TradeUp',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.getTheme(isDark: true),
      darkTheme: AppTheme.getTheme(isDark: true),

      // 국제화 설정
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ko'), // Korean
        Locale('ja'), // Japanese
        Locale('vi'), // Vietnamese
        Locale('tr'), // Turkish
      ],
      locale: Locale(currentLanguage),
    );
  }
}
