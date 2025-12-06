import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../caching/cache_manager.dart';
import '../constants/cache_keys.dart';
import '../init/log_helper.dart';

part 'theme_provider.g.dart';

/// Theme Mode State Management with Riverpod
///
/// This Notifier manages the app's theme mode (light/dark/system) with
/// automatic persistence using CacheManager.
///
/// **Features:**
/// - Persists theme choice to local storage
/// - Loads saved theme on app start
/// - Toggle between light/dark modes
/// - System theme mode support
/// - Type-safe with Riverpod code generation
///
/// **Benefits over traditional ChangeNotifier:**
/// - Compile-time safety
/// - No need to dispose
/// - Better performance (fine-grained reactivity)
/// - Easier to test
/// - Automatic persistence
///
/// **Usage:**
/// ```dart
/// // In widget
/// final themeMode = ref.watch(themeProvider);
///
/// // Toggle theme
/// ref.read(themeProvider.notifier).toggleTheme();
///
/// // Set specific mode
/// ref.read(themeProvider.notifier).setThemeMode(ThemeMode.dark);
/// ```
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    // Load saved theme mode from cache
    _loadThemeMode();

    // Return system mode as initial value
    // (will be updated asynchronously by _loadThemeMode)
    return ThemeMode.system;
  }

  /// Load saved theme mode from cache
  Future<void> _loadThemeMode() async {
    try {
      final savedTheme = await CacheManager.instance.getString(
        CacheKeys.themeMode,
      );

      if (savedTheme != null) {
        final themeMode = _parseThemeMode(savedTheme);
        state = themeMode;
        LogHelper.info('✅ Loaded theme: ${themeMode.name}');
      } else {
        LogHelper.debug('No saved theme found, using system default');
      }
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to load theme mode',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Save theme mode to cache
  Future<void> _saveThemeMode(ThemeMode mode) async {
    try {
      await CacheManager.instance.saveString(CacheKeys.themeMode, mode.name);
      LogHelper.info('💾 Saved theme: ${mode.name}');
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to save theme mode',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Parse theme mode from string
  ThemeMode _parseThemeMode(String value) {
    switch (value.toLowerCase()) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// Toggle between light and dark themes
  ///
  /// If currently in system mode, switches to light.
  /// If in light mode, switches to dark.
  /// If in dark mode, switches to light.
  void toggleTheme() {
    final newMode = switch (state) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
    };

    setThemeMode(newMode);
  }

  /// Set theme mode explicitly and persist to cache
  ///
  /// ```dart
  /// ref.read(themeProvider.notifier).setThemeMode(ThemeMode.dark);
  /// ```
  void setThemeMode(ThemeMode mode) {
    state = mode;
    _saveThemeMode(mode);
    LogHelper.info('🎨 Theme changed to: ${mode.name}');
  }

  /// Switch to light theme
  void setLightTheme() => setThemeMode(ThemeMode.light);

  /// Switch to dark theme
  void setDarkTheme() => setThemeMode(ThemeMode.dark);

  /// Switch to system theme
  void setSystemTheme() => setThemeMode(ThemeMode.system);

  /// Check if currently in dark mode
  bool get isDarkMode => state == ThemeMode.dark;

  /// Check if currently in light mode
  bool get isLightMode => state == ThemeMode.light;

  /// Check if using system theme
  bool get isSystemMode => state == ThemeMode.system;
}
