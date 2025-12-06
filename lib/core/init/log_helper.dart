import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Log Helper - Standardized Logging Utility
///
/// Wrapper around the `logger` package to provide consistent,
/// beautiful console output across the entire application.
///
/// **Features:**
/// - Color-coded log levels (debug, info, warning, error)
/// - Stack trace support for errors
/// - Automatic disabling in release mode
/// - Pretty formatting with emoji indicators
///
/// **Usage:**
/// ```dart
/// LogHelper.info('User logged in successfully');
/// LogHelper.error('Failed to fetch data', error: e, stackTrace: st);
/// LogHelper.debug('Cache hit for key: $key');
/// ```
class LogHelper {
  LogHelper._();

  // Singleton logger instance with custom configuration
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // Number of method calls to display
      errorMethodCount: 5, // Number of method calls for errors
      lineLength: 80, // Width of output
      colors: true, // Colorful output
      printEmojis: true, // Print emojis for log levels
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    // Only log in debug mode
    filter: _LogFilter(),
  );

  // ========================================================================
  // LOG LEVEL METHODS
  // ========================================================================

  /// Log debug message (verbose information)
  ///
  /// Use for detailed diagnostic information.
  /// Example: Cache operations, state changes, etc.
  ///
  /// ```dart
  /// LogHelper.debug('Fetching user profile from cache...');
  /// ```
  static void debug(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log informational message
  ///
  /// Use for general information about app flow.
  /// Example: User actions, successful operations, etc.
  ///
  /// ```dart
  /// LogHelper.info('✅ User logged in successfully');
  /// ```
  static void info(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log warning message
  ///
  /// Use for potentially harmful situations that don't stop execution.
  /// Example: Deprecated API usage, fallback behavior, etc.
  ///
  /// ```dart
  /// LogHelper.warning('⚠️ Using fallback base URL');
  /// ```
  static void warning(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error message
  ///
  /// Use for error conditions that require attention.
  /// Example: Network failures, parsing errors, etc.
  ///
  /// ```dart
  /// LogHelper.error(
  ///   '❌ Failed to fetch user data',
  ///   error: exception,
  ///   stackTrace: stackTrace,
  /// );
  /// ```
  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log fatal error message
  ///
  /// Use for critical errors that may crash the app.
  /// Example: Initialization failures, unrecoverable errors, etc.
  ///
  /// ```dart
  /// LogHelper.fatal(
  ///   '💥 Critical initialization failure',
  ///   error: exception,
  ///   stackTrace: stackTrace,
  /// );
  /// ```
  static void fatal(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  // ========================================================================
  // CONVENIENCE METHODS
  // ========================================================================

  /// Log a horizontal separator line
  ///
  /// Useful for visually separating sections in logs.
  ///
  /// ```dart
  /// LogHelper.separator();
  /// LogHelper.info('Starting new test suite');
  /// LogHelper.separator();
  /// ```
  static void separator() {
    if (kDebugMode) {
      // ignore: avoid_print
      print('═' * 80);
    }
  }

  /// Log a section header
  ///
  /// Creates a visually distinct header in logs.
  ///
  /// ```dart
  /// LogHelper.section('NETWORK REQUESTS');
  /// ```
  static void section(String title) {
    if (kDebugMode) {
      separator();
      info('  $title');
      separator();
    }
  }

  /// Log JSON data with pretty formatting
  ///
  /// Useful for debugging API responses.
  ///
  /// ```dart
  /// LogHelper.json(responseData);
  /// ```
  static void json(Map<String, dynamic> data) {
    _logger.t(data);
  }
}

/// Custom log filter that only logs in debug mode
class _LogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    // Only log in debug mode
    return kDebugMode;
  }
}
