import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../caching/cache_manager.dart';
import '../network/network_manager.dart';
import 'log_helper.dart';

/// App Initializer
///
/// Centralized initialization for all core services and configurations.
/// Ensures proper setup before the app starts.
///
/// **Responsibilities:**
/// - Initialize Flutter bindings
/// - Configure system UI (status bar, orientation)
/// - Initialize cache manager
/// - Initialize network manager
/// - Set up error handlers
/// - Configure logging
///
/// **Usage:**
/// ```dart
/// void main() async {
///   await AppInitializer.initialize();
///   runApp(const MyApp());
/// }
/// ```
class AppInitializer {
  AppInitializer._(); // Private constructor

  /// Initialize all core services
  ///
  /// Call this method in main() before runApp().
  ///
  /// ```dart
  /// Future<void> main() async {
  ///   await AppInitializer.initialize();
  ///   runApp(const ProviderScope(child: MyApp()));
  /// }
  /// ```
  static Future<void> initialize() async {
    try {
      LogHelper.section('🚀 INITIALIZING HYPERFRAME');

      // 1. Ensure Flutter bindings are initialized
      WidgetsFlutterBinding.ensureInitialized();
      LogHelper.info('✅ Flutter bindings initialized');

      // 2. Configure system UI
      await _configureSystemUI();

      // 3. Initialize CacheManager
      await CacheManager.instance.init();

      // 4. Initialize NetworkManager
      await NetworkManager.instance.init();

      // 5. Set up error handlers
      _setupErrorHandlers();

      LogHelper.section('✅ INITIALIZATION COMPLETE');
    } catch (e, stackTrace) {
      LogHelper.fatal(
        '💥 Critical initialization failure',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Configure system UI appearance
  static Future<void> _configureSystemUI() async {
    try {
      // Set preferred orientations (allow all by default)
      // Uncomment to lock to portrait:
      // await SystemChrome.setPreferredOrientations([
      //   DeviceOrientation.portraitUp,
      //   DeviceOrientation.portraitDown,
      // ]);

      // Configure system overlay style (status bar, navigation bar)
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );

      LogHelper.info('✅ System UI configured');
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to configure system UI',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Set up global error handlers
  static void _setupErrorHandlers() {
    try {
      // Handle Flutter framework errors
      FlutterError.onError = (FlutterErrorDetails details) {
        LogHelper.fatal(
          '🔥 Flutter Error',
          error: details.exception,
          stackTrace: details.stack,
        );

        // In debug mode, show red screen
        // In release mode, show custom error UI
        FlutterError.presentError(details);
      };

      // Handle errors outside Flutter framework
      PlatformDispatcher.instance.onError = (error, stack) {
        LogHelper.fatal('🔥 Platform Error', error: error, stackTrace: stack);
        return true; // Handled
      };

      LogHelper.info('✅ Error handlers configured');
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to setup error handlers',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Pre-cache assets (images, fonts, etc.)
  ///
  /// Optional: Call this if you have assets to pre-load.
  ///
  /// ```dart
  /// await AppInitializer.precacheAssets(context);
  /// ```
  static Future<void> precacheAssets(BuildContext context) async {
    try {
      LogHelper.info('📦 Precaching assets...');

      // Example: Precache images
      // await precacheImage(
      //   const AssetImage('assets/images/logo.png'),
      //   context,
      // );

      LogHelper.info('✅ Assets precached');
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to precache assets',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Reset all app data
  ///
  /// Useful for logout or testing.
  ///
  /// ```dart
  /// await AppInitializer.reset();
  /// ```
  static Future<void> reset() async {
    try {
      LogHelper.warning('🔄 Resetting app data...');

      // Clear all cached data
      await CacheManager.instance.clearAll();

      LogHelper.info('✅ App data reset complete');
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to reset app data',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
