import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

/// Theme Mode State Management with Riverpod
///
/// This Notifier manages the app's theme mode (light/dark/system).
/// Using Riverpod's code generation for type-safe state management.
///
/// Benefits over traditional ChangeNotifier:
/// - Compile-time safety
/// - No need to dispose
/// - Better performance (fine-grained reactivity)
/// - Easier to test
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    // Initialize with system theme mode
    return ThemeMode.system;
  }

  /// Toggle between light and dark themes
  void toggleTheme() {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
  }

  /// Set theme mode explicitly
  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  /// Check if currently in dark mode
  bool get isDarkMode => state == ThemeMode.dark;

  /// Check if currently in light mode
  bool get isLightMode => state == ThemeMode.light;

  /// Check if using system theme
  bool get isSystemMode => state == ThemeMode.system;
}
