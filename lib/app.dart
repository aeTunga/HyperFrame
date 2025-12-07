import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_preview/device_preview.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/router/app_router.dart';

/// Main Application Widget
///
/// Integrates:
/// - DevicePreview for proper device simulation
/// - Riverpod for state management
/// - GoRouter for declarative navigation with ShellRoute for HyperConsole
/// - Material 3 theming
/// - HyperConsole debug overlay (debug mode only, injected via ShellRoute)
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      // 🎯 CRITICAL: DevicePreview Integration
      locale: DevicePreview.locale(context),
      builder: (context, child) {
        // HyperConsole button injected via ShellRoute in router
        return DevicePreview.appBuilder(context, child);
      },

      title: 'HyperFrame',
      debugShowCheckedModeBanner: false,

      // Theme Configuration
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,

      // GoRouter Configuration (includes HyperConsole via ShellRoute)
      routerConfig: router,
    );
  }
}
