import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trade_up/l10n/app_localizations.dart';

import 'core/providers/language_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Native splash를 유지하고 Flutter가 준비되면 제거
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(ProviderScope(child: const TradeUpApp()));
}

class TradeUpApp extends ConsumerStatefulWidget {
  const TradeUpApp({super.key});

  @override
  ConsumerState<TradeUpApp> createState() => _TradeUpAppState();
}

class _TradeUpAppState extends ConsumerState<TradeUpApp> {
  @override
  void initState() {
    super.initState();
    // 실제 기기에서 더 안정적인 splash 제거를 위해 지연 시간 추가
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          FlutterNativeSplash.remove();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
        Locale('vi'), // Vietnamese
        Locale('ko'), // Korean
      ],
      locale: Locale(currentLanguage),
    );
  }
}
