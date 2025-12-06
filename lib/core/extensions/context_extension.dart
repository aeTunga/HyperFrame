import 'dart:math' as math;

import 'package:flutter/material.dart';

/// BuildContext Extensions
///
/// Convenient extensions on BuildContext to simplify common operations
/// like accessing theme, media queries, navigation, and responsive sizes.
///
/// **Usage:**
/// ```dart
/// Widget build(BuildContext context) {
///   final isDark = context.isDark;
///   final width = context.width;
///   final isTablet = context.isTablet;
///
///   return Container(
///     width: context.percentWidth(0.8), // 80% of screen width
///     height: context.percentHeight(0.5), // 50% of screen height
///   );
/// }
/// ```
extension ContextExtensions on BuildContext {
  // ========================================================================
  // THEME ACCESS
  // ========================================================================

  /// Get current theme data
  ThemeData get theme => Theme.of(this);

  /// Get current color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get current text theme
  TextTheme get textTheme => theme.textTheme;

  /// Check if current theme is dark mode
  bool get isDark => theme.brightness == Brightness.dark;

  /// Check if current theme is light mode
  bool get isLight => theme.brightness == Brightness.light;

  /// Get primary color
  Color get primaryColor => colorScheme.primary;

  /// Get background color
  Color get backgroundColor => colorScheme.surface;

  /// Get text color
  Color get textColor => colorScheme.onSurface;

  // ========================================================================
  // MEDIA QUERY ACCESS
  // ========================================================================

  /// Get screen size
  Size get screenSize => MediaQuery.of(this).size;

  /// Get screen width
  double get width => screenSize.width;

  /// Get screen height
  double get height => screenSize.height;

  /// Get screen diagonal (for device size classification)
  double get diagonal {
    return math.sqrt(width * width + height * height);
  }

  /// Get screen orientation
  Orientation get orientation => MediaQuery.of(this).orientation;

  /// Check if device is in landscape mode
  bool get isLandscape => orientation == Orientation.landscape;

  /// Check if device is in portrait mode
  bool get isPortrait => orientation == Orientation.portrait;

  /// Get device pixel ratio
  double get pixelRatio => MediaQuery.of(this).devicePixelRatio;

  /// Get text scale factor
  double get textScaleFactor => MediaQuery.of(this).textScaler.scale(1.0);

  /// Get safe area padding (notch, status bar, etc.)
  EdgeInsets get padding => MediaQuery.of(this).padding;

  /// Get view insets (keyboard, etc.)
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  /// Check if keyboard is visible
  bool get isKeyboardVisible => viewInsets.bottom > 0;

  // ========================================================================
  // RESPONSIVE BREAKPOINTS
  // ========================================================================

  /// Check if device is a phone (small screen)
  /// Width < 600dp
  bool get isPhone => width < 600;

  /// Check if device is a tablet (medium screen)
  /// 600dp <= Width < 1024dp
  bool get isTablet => width >= 600 && width < 1024;

  /// Check if device is a desktop (large screen)
  /// Width >= 1024dp
  bool get isDesktop => width >= 1024;

  /// Check if screen is small (< 360dp)
  bool get isSmallScreen => width < 360;

  /// Check if screen is extra large (>= 1440dp)
  bool get isExtraLargeScreen => width >= 1440;

  // ========================================================================
  // RESPONSIVE HELPERS
  // ========================================================================

  /// Get percentage of screen width
  ///
  /// ```dart
  /// width: context.percentWidth(0.8), // 80% of screen width
  /// ```
  double percentWidth(double percent) => width * percent;

  /// Get percentage of screen height
  ///
  /// ```dart
  /// height: context.percentHeight(0.5), // 50% of screen height
  /// ```
  double percentHeight(double percent) => height * percent;

  /// Responsive value based on screen size
  ///
  /// ```dart
  /// fontSize: context.responsive<double>(
  ///   mobile: 14,
  ///   tablet: 16,
  ///   desktop: 18,
  /// ),
  /// ```
  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  /// Responsive spacing based on screen size
  ///
  /// ```dart
  /// padding: EdgeInsets.all(context.spacing),
  /// ```
  double get spacing =>
      responsive<double>(mobile: 8.0, tablet: 12.0, desktop: 16.0);

  /// Responsive margin based on screen size
  double get margin =>
      responsive<double>(mobile: 16.0, tablet: 24.0, desktop: 32.0);

  /// Responsive padding based on screen size
  double get responsivePadding =>
      responsive<double>(mobile: 16.0, tablet: 24.0, desktop: 32.0);

  // ========================================================================
  // NAVIGATION HELPERS
  // ========================================================================

  /// Get navigator state
  NavigatorState get navigator => Navigator.of(this);

  /// Check if can pop
  bool get canPop => navigator.canPop();

  /// Pop current route
  void pop<T>([T? result]) => navigator.pop(result);

  /// Push new route
  Future<T?> push<T>(Route<T> route) => navigator.push(route);

  /// Push named route
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return navigator.pushNamed(routeName, arguments: arguments);
  }

  /// Push replacement route
  Future<T?> pushReplacement<T, TO>(Route<T> route, {TO? result}) {
    return navigator.pushReplacement(route, result: result);
  }

  /// Push replacement named route
  Future<T?> pushReplacementNamed<T, TO>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return navigator.pushReplacementNamed(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  /// Pop until first route
  void popUntilFirst() => navigator.popUntil((route) => route.isFirst);

  // ========================================================================
  // SNACKBAR HELPERS
  // ========================================================================

  /// Show snackbar
  ///
  /// ```dart
  /// context.showSnackBar('Success!');
  /// ```
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message), duration: duration, action: action),
    );
  }

  /// Show error snackbar
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Show success snackbar
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ========================================================================
  // DIALOG HELPERS
  // ========================================================================

  /// Show dialog
  Future<T?> showCustomDialog<T>(Widget dialog) {
    return showDialog<T>(context: this, builder: (_) => dialog);
  }

  /// Show loading dialog
  void showLoadingDialog() {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  /// Hide loading dialog
  void hideLoadingDialog() {
    if (canPop) pop();
  }

  // ========================================================================
  // FOCUS HELPERS
  // ========================================================================

  /// Unfocus current text field (hide keyboard)
  void unfocus() {
    FocusScope.of(this).unfocus();
  }

  /// Request focus for a node
  void requestFocus(FocusNode node) {
    FocusScope.of(this).requestFocus(node);
  }
}
