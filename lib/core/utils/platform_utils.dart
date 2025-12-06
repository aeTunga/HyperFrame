import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kDebugMode;

/// Platform Detection Utilities
///
/// Provides centralized platform detection logic for HyperFrame.
/// This eliminates code duplication and provides consistent platform checks
/// across the entire application.
class PlatformUtils {
  PlatformUtils._(); // Private constructor to prevent instantiation

  /// Check if running on desktop platform (macOS, Windows, or Linux)
  static bool get isDesktop =>
      Platform.isMacOS || Platform.isWindows || Platform.isLinux;

  /// Check if running on mobile platform (iOS or Android)
  static bool get isMobile => Platform.isIOS || Platform.isAndroid;

  /// Check if currently in debug mode
  static bool get isDebugMode => kDebugMode;

  /// Check if DevicePreview simulation should be enabled
  /// (Desktop + Debug mode)
  static bool get shouldEnableSimulation => isDebugMode && isDesktop;

  /// Get current platform name as string
  static String get platformName {
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }

  /// Check if running on specific platform
  static bool get isAndroid => Platform.isAndroid;
  static bool get isIOS => Platform.isIOS;
  static bool get isMacOS => Platform.isMacOS;
  static bool get isWindows => Platform.isWindows;
  static bool get isLinux => Platform.isLinux;
}
