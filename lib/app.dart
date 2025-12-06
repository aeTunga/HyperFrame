import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';
import 'screens/home_screen.dart';

/// Main Application Widget
///
/// Integrates with DevicePreview for proper simulation:
/// - locale: DevicePreview.locale(context) - Enables locale switching
/// - builder: DevicePreview.appBuilder - Wraps app in device frame
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      // 🎯 CRITICAL: DevicePreview Integration
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      title: 'HyperFrame',
      debugShowCheckedModeBanner: false,

      // Theme Configuration
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,

      home: const HomeScreen(),
    );
  }
}
