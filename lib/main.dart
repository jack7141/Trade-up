import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(ProviderScope(child: const TradeUpApp()));
}

class TradeUpApp extends ConsumerWidget {
  const TradeUpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'TradeUp',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.getTheme(isDark: true),
      darkTheme: AppTheme.getTheme(isDark: true),
    );
  }
}
